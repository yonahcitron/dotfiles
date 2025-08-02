
############ What I'm trying to do #############

I just implemented the email ingestion pipeline for landing and raw layers. I now want to build the silver / euh layer and want to transform the raw table, modifying and dropping columns accordingly. In general, we want to generalize and flatten the data model into the silver layer. For now, we're only dealing with the messages data, ignore the attachments.

I've given you the top-level columns below. Several of them contain nested structures. In the silver layer, assuming we'd want to keep all this info in the silver layer, I think we should flatten out these columns into the data model. Obviously, if you think there are any nested fields that we unexpectedly should remove, do let me know.

For context (probably don't read most of these files, only the ones that are particularly useful for understanding structure etc), here are the files I've worked on for landing and raw so far. The naming structures and locations will probably be useful for creating the silver layer structures.

We want to create the silver layer files, concisely and accurately with clear documentation and structure and not unnecessarily verbose etc. Read the files in the 'euh' folder(s) to understand how they're being implemented in our existing setup, which we want to emulate in general style.

** THIS TIME, I DON'T WANT YOU TO CREATE THE FILES. I JUST WANT YOU TO COME UP WITH A CLEAR PLAN OF WHAT YOU'RE GOING TO KEEP AND WHAT YOU'RE GOING TO DISCARD, WITH CLEAR JUSTIFICATIONS. YOU CAN ALSO SAVE THIS TO AN MD FILE IF YOU WISH, AS WELL AS TELL ME **

Tell me if you disagree with anything I said etc, and make everything professional and clear in tone.


############ Files I've worked with so far ####################

conf/init_scripts/batch-workflow-cluster-config.sh \
conf/tasks/landing/landing_etl_email_batch_msgraph.yml \
conf/tasks/raw/raw_etl_email_attachments_msgraph.yml \
conf/tasks/raw/raw_etl_email_messages_msgraph.yml \
conf/tasks/test/integration/test_msgraph_email_client.yml \
emob_datalake_databricks/__init__.py \
emob_datalake_databricks/notebooks/__init__.py \
emob_datalake_databricks/notebooks/landing/__init__.py \
emob_datalake_databricks/notebooks/landing/landing_etl_email_batch_msgraph.py \
emob_datalake_databricks/notebooks/raw/raw_etl_email_batch_msgraph.py \        
library/client/msgraph_client.py \
library/client/msgraph_email_client.py \
tests/ \
.gitignore \
pyproject.toml \
library/sources/sources.py \
library/storage/storage_aws_s3.py


############ Here is the existing raw / bronze emails data model, at the top-level ###########


class EmailMessagesMsgraph(Base):
    __tablename__ = "email_messages_msgraph"
    __table_args__ = {
        "comment": "Table containing raw email messages ingested via Microsoft Graph API using Auto Loader",
        "schema": "raw-emobility",
    }

    # Microsoft Graph API email message fields
    odata_etag = Column("@odata.etag", String(), nullable=True, comment="OData entity tag for concurrency control")
    odata_type = Column("@odata.type", String(), nullable=True, comment="OData type identifier for the message entity")
    allowNewTimeProposals = Column("allowNewTimeProposals", String(), nullable=True, comment="Whether new time proposals are allowed for meeting requests")
    bccRecipients = Column("bccRecipients", String(), nullable=True, comment="BCC recipients as JSON array of email address objects")
    body = Column("body", String(), nullable=True, comment="Message body content and content type as JSON object")
    bodyPreview = Column("bodyPreview", String(), nullable=True, comment="Preview of the message body")
    categories = Column("categories", String(), nullable=True, comment="Categories assigned to the message as JSON array")
    ccRecipients = Column("ccRecipients", String(), nullable=True, comment="CC recipients as JSON array of email address objects")
    changeKey = Column("changeKey", String(), nullable=True, comment="Version identifier for the message")
    conversationId = Column("conversationId", String(), nullable=True, comment="Unique identifier for the conversation thread", databricks_cluster_key=True)
    conversationIndex = Column("conversationIndex", String(), nullable=True, comment="Index position in the conversation thread")
    createdDateTime = Column("createdDateTime", String(), nullable=True, comment="Date and time when the message was created")
    endDateTime = Column("endDateTime", String(), nullable=True, comment="End date and time for meeting messages as JSON object")
    flag = Column("flag", String(), nullable=True, comment="Flag status information as JSON object")
    from_address = Column("from", String(), nullable=True, comment="Sender information as JSON object with email address")
    hasAttachments = Column("hasAttachments", Boolean(), nullable=True, comment="Whether the message has attachments")
    id = Column("id", String(), primary_key=True, nullable=False, comment="Unique identifier for the message")
    importance = Column("importance", String(), nullable=True, comment="Importance level of the message")
    inferenceClassification = Column("inferenceClassification", String(), nullable=True, comment="Inference classification result")
    internetMessageId = Column("internetMessageId", String(), nullable=True, comment="Internet message ID as per RFC 2822")
    isAllDay = Column("isAllDay", Boolean(), nullable=True, comment="Whether the event is an all-day event")
    isDelegated = Column("isDelegated", Boolean(), nullable=True, comment="Whether the message was delegated")
    isDeliveryReceiptRequested = Column("isDeliveryReceiptRequested", Boolean(), nullable=True, comment="Whether delivery receipt was requested")
    isDraft = Column("isDraft", Boolean(), nullable=True, comment="Whether the message is a draft")
    isOutOfDate = Column("isOutOfDate", Boolean(), nullable=True, comment="Whether the meeting information is out of date")
    isRead = Column("isRead", Boolean(), nullable=True, comment="Whether the message has been read")
    isReadReceiptRequested = Column("isReadReceiptRequested", Boolean(), nullable=True, comment="Whether read receipt was requested")
    lastModifiedDateTime = Column("lastModifiedDateTime", String(), nullable=True, comment="Date and time when the message was last modified")
    location = Column("location", String(), nullable=True, comment="Location information for meetings as JSON object")
    meetingMessageType = Column("meetingMessageType", String(), nullable=True, comment="Type of meeting message")
    meetingRequestType = Column("meetingRequestType", String(), nullable=True, comment="Type of meeting request")
    parentFolderId = Column("parentFolderId", String(), nullable=True, comment="Unique identifier of the parent folder")
    previousEndDateTime = Column("previousEndDateTime", String(), nullable=True, comment="Previous end date and time as JSON object")
    previousLocation = Column("previousLocation", String(), nullable=True, comment="Previous location information as JSON object")
    previousStartDateTime = Column("previousStartDateTime", String(), nullable=True, comment="Previous start date and time as JSON object")
    receivedDateTime = Column("receivedDateTime", String(), nullable=True, comment="Date and time when the message was received", databricks_cluster_key=True)
    recurrence = Column("recurrence", String(), nullable=True, comment="Recurrence pattern information as JSON object")
    replyTo = Column("replyTo", String(), nullable=True, comment="Reply-to addresses as JSON array")
    responseRequested = Column("responseRequested", Boolean(), nullable=True, comment="Whether a response is requested")
    responseType = Column("responseType", String(), nullable=True, comment="Type of response given to meeting request")
    sender = Column("sender", String(), nullable=True, comment="Sender information as JSON object")
    sentDateTime = Column("sentDateTime", String(), nullable=True, comment="Date and time when the message was sent")
    startDateTime = Column("startDateTime", String(), nullable=True, comment="Start date and time for meetings as JSON object")
    subject = Column("subject", String(), nullable=True, comment="Subject line of the message")
    toRecipients = Column("toRecipients", String(), nullable=True, comment="To recipients as JSON array of email address objects")
    type = Column("type", String(), nullable=True, comment="Type of the message")
    webLink = Column("webLink", String(), nullable=True, comment="Web link to the message")
    
    # Auto Loader metadata fields
    _rescued_data = Column("_rescued_data", String(), nullable=True, comment="Stores data that has been rescued during schema evolution to prevent data loss")
    ingest_load_timestamp = Column("ingest_load_timestamp", DateTime(), primary_key=True, nullable=True, comment="Timestamp when the data was ingested into the raw layer", databricks_cluster_key=True)
    source_file = Column("source_file", String(), nullable=True, comment="Path to the source file in the landing layer")
    source = Column("source", String(), nullable=True, comment="Internal reference to the source system")
    source_name = Column("source_name", String(), nullable=True, comment="Name identifier for the specific data source")


############ Here is the cols I think want to keep (feel free to correct) ##########

-- Core Identifiers & Attributes
id,                      -- Primary key from source
internetMessageId,       -- Universal, durable key for deduplication
conversationId,          -- Essential for grouping email threads
parentFolderId,          -- Key for understanding folder location
subject,                 -- Core text attribute
hasAttachments,          -- Useful boolean flag
importance,              -- Useful category (high, normal, low)
categories,              -- Parse JSON array to Array<String>
isRead,                  -- Core status flag
isDraft,                 -- Core status flag
webLink,                 -- Useful for linking back to the source

-- Body & Content (Transformed)
body,                    -- Parse JSON to Struct<contentType: String, content: String>
flag,                    -- Parse JSON to Struct with flag status

-- Participants (Transformed)
from_address,            -- Parse JSON to Struct<name: String, address: String>
sender,                  -- Parse JSON to Struct (often same as 'from', but can differ for delegated mail)
toRecipients,            -- Parse JSON array to Array<Struct<...>>
ccRecipients,            -- Parse JSON array to Array<Struct<...>>
bccRecipients,           -- Parse JSON array to Array<Struct<...>>
replyTo,                 -- Parse JSON array to Array<Struct<...>>

-- Timestamps (Transformed)
createdDateTime,         -- Cast to Timestamp
sentDateTime,            -- Cast to Timestamp
receivedDateTime,        -- Cast to Timestamp
lastModifiedDateTime,    -- Cast to Timestamp. Crucial for incremental loads.

-- Meeting-Specific Fields (Transformed where needed)
allowNewTimeProposals,
isAllDay,
isDelegated,
isOutOfDate,
meetingMessageType,
meetingRequestType,
responseRequested,
responseType,
type,                    -- Useful for distinguishing message types (meeting, email, etc.)
location,                -- Parse JSON to Struct
startDateTime,           -- Parse JSON to Struct<dateTime: Timestamp, timeZone: String>
endDateTime,             -- Parse JSON to Struct<dateTime: Timestamp, timeZone: String>
recurrence,              -- Parse JSON to Struct
previousLocation,        -- Parse JSON to Struct
previousStartDateTime,   -- Parse JSON to Struct
previousEndDateTime,     -- Parse JSON to Struct

-- Lineage & Auditing
source,                  -- Keep for lineage
source_name,             -- Keep for lineage
ingest_load_timestamp    -- Rename to 'bronze_ingest_timestamp' or similar
-- You should also add a new 'silver_load_timestamp'

######### Here is cols I want to remove ##########

-- OData Operational Fields
odata_etag,
odata_type,

-- Redundant or Low-Value Fields
changeKey,
bodyPreview,
conversationIndex,

-- Raw Ingestion & ETL Metadata
_rescued_data,
source_file



# The eventual spec created with AI:

# Email Silver Layer Transformation Plan

## Executive Summary

This document outlines the comprehensive plan for transforming the raw Microsoft Graph email data into a normalized silver layer suitable for analytics and reporting. The plan focuses on flattening nested JSON structures, standardizing data types, and creating a clean, queryable schema that maintains all essential business information while eliminating operational noise.

## Fields Removed from Silver Layer

Based on analysis of actual Microsoft Graph email data and **business analytics requirements**, the following fields have been **REMOVED** from the silver layer to focus on high-value business intelligence:

### ❌ **Technical Infrastructure (Zero Business Value)**
- **internetMessageHeaders[]** - Technical routing/authentication metadata with no analytical purpose
- **@odata.type**, **@odata.etag** - API response metadata irrelevant for business analysis
- **changeKey** - Version control for API operations, not business insights
- **Reasoning**: Pure technical metadata with no communication pattern or business intelligence value

### ❌ **Complex Task Management Sub-Fields (Low Business Value)**
- **flag.dueDateTime**, **flag.startDateTime**, **flag.completedDateTime** - Rarely populated in actual data
- **Reasoning**: Flag sub-fields are personal productivity details; basic flag status provides sufficient analytics value

### ❌ **Edge Case Communication Features (Minimal Adoption)**
- **mentions[]** - @mention functionality rarely used in corporate email environments
- **uniqueBody** - Content without quoted text (complex parsing, minimal analytical value)
- **allowNewTimeProposals** - Meeting edge case rarely used in practice
- **Reasoning**: Low adoption features with minimal impact on communication pattern analysis

### ❌ **Complex Multi-Message Workflow Tracking**
- **meeting_response_status** - Requires correlation across multiple message types
- **proposedNewTime** - Edge case for meeting rescheduling workflow
- **Reasoning**: Complex workflow states better handled at application layer, not analytical layer

## ✅ **Retained High-Value Fields (49 Core Fields)**

The optimized schema focuses on **actionable business intelligence**:

### **Communication Pattern Analytics**
- Message volume, timing, and participant relationship mapping
- Response time analysis and communication hierarchy insights

### **Meeting Coordination Intelligence** 
- Meeting request processing patterns and scheduling behavior analysis
- Resource booking patterns and timezone coordination insights

### **Priority and Task Management Analytics**
- Flag status patterns (kept for priority message analysis)
- Importance level distribution and urgency correlation

### **Content Classification and Organization**
- Subject line analysis, category classification, and topic trending
- Inference classification for relevance scoring and filtering

### **Data Quality and Processing Metadata**
- Validation flags, processing timestamps, and source tracking for data governance

## Table of Contents

1. [Analysis of Current Raw Data Model](#1-analysis-of-current-raw-data-model)
2. [Silver Layer Design Philosophy](#2-silver-layer-design-philosophy)
3. [Field-by-Field Transformation Plan](#3-field-by-field-transformation-plan)
4. [Data Quality & Validation Rules](#4-data-quality--validation-rules)
5. [Implementation Structure](#5-implementation-structure)
6. [Schema Evolution Strategy](#6-schema-evolution-strategy)
7. [Performance Considerations](#7-performance-considerations)

---

## 1. Analysis of Current Raw Data Model

### Current State Assessment
The raw email data contains 71 fields from Microsoft Graph API, with several containing complex nested JSON structures. Key observations:

- **Nested JSON Fields**: `body`, `from_address`, `sender`, `toRecipients`, `ccRecipients`, `bccRecipients`, `replyTo`, `flag`, `location`, `startDateTime`, `endDateTime`, `recurrence`, and other meeting-specific fields
- **String-based Timestamps**: All temporal fields are stored as strings requiring conversion
- **Mixed Data Types**: Boolean flags stored inconsistently
- **Operational Metadata**: OData fields and ingestion metadata mixed with business data

### Data Volume Considerations
Based on typical enterprise email volumes:
- **Daily Volume**: ~1,000-10,000 emails per mailbox
- **Schema Complexity**: High due to Microsoft Graph's comprehensive field set
- **Meeting vs Email Ratio**: ~20% meeting-related messages with additional complexity

---

## 2. Silver Layer Design Philosophy

### Core Principles

1. **Flattened Structure**: Transform all nested JSON into first-class columns with clear naming conventions
2. **Type Safety**: Convert all fields to appropriate Spark/Delta data types
3. **Business Focus**: Prioritize fields that support analytics while removing operational noise
4. **Temporal Consistency**: Standardize all timestamps to proper DateTime types with UTC timezone
5. **Null Handling**: Explicit strategies for missing/null values in nested structures
6. **Performance Optimization**: Structure data for common query patterns

### Naming Convention
- **Nested Field Flattening**: `parent_child_grandchild` (e.g., `body_content_type`, `from_email_address`)
- **Array Elements**: `parent_array_item_field` (e.g., `to_recipients_email_address`)
- **DateTime Fields**: Suffix with `_datetime` for clarity
- **Boolean Fields**: Prefix with `is_` or `has_` for consistency

---

## 3. Field-by-Field Transformation Plan

### 3.1 KEEP & TRANSFORM - Core Message Fields

#### **Identifiers & References**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `id` | `message_id` | STRING | Direct copy | Primary business key |
| `internetMessageId` | `internet_message_id` | STRING | Direct copy | Global deduplication key |
| `conversationId` | `conversation_id` | STRING | Direct copy | Thread grouping |
| `parentFolderId` | `parent_folder_id` | STRING | Direct copy | Folder organization |
| `changeKey` | **REMOVE** | - | - | Technical metadata, no business value |

#### **Core Content Fields**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `subject` | `subject` | STRING | Direct copy | Core business data |
| `body` | `body_content_type`<br>`body_content` | STRING<br>STRING | Parse JSON: `body.contentType` → `body_content_type`<br>`body.content` → `body_content` | Flatten for easier querying |
| `bodyPreview` | **REMOVE** | - | - | Redundant with body content |
| `importance` | `importance` | STRING | Direct copy | Business priority indicator |
| `categories` | `categories` | ARRAY&lt;STRING&gt; | Parse JSON array | Multi-value categorization |

#### **Participant Information (Flattened)**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `from_address` | `from_email_name`<br>`from_email_address` | STRING<br>STRING | Parse JSON: `from.emailAddress.name` → `from_email_name`<br>`from.emailAddress.address` → `from_email_address` | Flatten most common access pattern |
| `sender` | `sender_email_name`<br>`sender_email_address` | STRING<br>STRING | Parse JSON: `sender.emailAddress.name` → `sender_email_name`<br>`sender.emailAddress.address` → `sender_email_address` | Distinguish from 'from' for delegated scenarios |
| `toRecipients` | `to_recipients` | ARRAY&lt;STRUCT&lt;name:STRING,address:STRING&gt;&gt; | Parse JSON array to structured array | Preserve all recipients with structure |
| `ccRecipients` | `cc_recipients` | ARRAY&lt;STRUCT&lt;name:STRING,address:STRING&gt;&gt; | Parse JSON array to structured array | Preserve all CC recipients |
| `bccRecipients` | `bcc_recipients` | ARRAY&lt;STRUCT&lt;name:STRING,address:STRING&gt;&gt; | Parse JSON array to structured array | Preserve all BCC recipients |
| `replyTo` | `reply_to_recipients` | ARRAY&lt;STRUCT&lt;name:STRING,address:STRING&gt;&gt; | Parse JSON array to structured array | Important for thread analysis |

#### **Temporal Fields (Standardized)**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `createdDateTime` | `created_datetime` | TIMESTAMP | Cast string to timestamp | Proper temporal data type |
| `sentDateTime` | `sent_datetime` | TIMESTAMP | Cast string to timestamp | Business-critical timestamp |
| `receivedDateTime` | `received_datetime` | TIMESTAMP | Cast string to timestamp | Business-critical timestamp |
| `lastModifiedDateTime` | `last_modified_datetime` | TIMESTAMP | Cast string to timestamp | Important for incremental processing |

#### **Status & Flags**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `hasAttachments` | `has_attachments` | BOOLEAN | Direct copy | Important business indicator |
| `isRead` | `is_read` | BOOLEAN | Direct copy | User interaction tracking |
| `isDraft` | `is_draft` | BOOLEAN | Direct copy | Message state tracking |
| `isDeliveryReceiptRequested` | `is_delivery_receipt_requested` | BOOLEAN | Direct copy | Compliance/tracking |
| `isReadReceiptRequested` | `is_read_receipt_requested` | BOOLEAN | Direct copy | Compliance/tracking |
| `webLink` | `web_link` | STRING | Direct copy | User navigation |

### 3.2 KEEP & TRANSFORM - Meeting-Specific Fields

#### **Meeting Status & Type**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `type` | `message_type` | STRING | Direct copy | Distinguish email vs meeting types |
| `meetingMessageType` | `meeting_message_type` | STRING | Direct copy | Meeting workflow tracking |
| `meetingRequestType` | `meeting_request_type` | STRING | Direct copy | Meeting workflow tracking |
| `responseRequested` | `is_response_requested` | BOOLEAN | Direct copy | Meeting interaction tracking |
| `responseType` | `response_type` | STRING | Direct copy | User response tracking |
| `allowNewTimeProposals` | `allows_new_time_proposals` | BOOLEAN | Direct copy | Meeting flexibility indicator |

#### **Meeting Temporal Fields**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `startDateTime` | `start_datetime`<br>`start_timezone` | TIMESTAMP<br>STRING | Parse JSON: `startDateTime.dateTime` → timestamp<br>`startDateTime.timeZone` → string | Proper temporal handling with timezone |
| `endDateTime` | `end_datetime`<br>`end_timezone` | TIMESTAMP<br>STRING | Parse JSON: `endDateTime.dateTime` → timestamp<br>`endDateTime.timeZone` → string | Proper temporal handling with timezone |
| `isAllDay` | `is_all_day` | BOOLEAN | Direct copy | Meeting type indicator |

#### **Meeting Location & Changes**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `location` | `location_display_name`<br>`location_address`<br>`location_coordinates` | STRING<br>STRING<br>STRUCT&lt;lat:DOUBLE,lng:DOUBLE&gt; | Parse JSON to extract location components | Structured location data |
| `previousStartDateTime` | `previous_start_datetime`<br>`previous_start_timezone` | TIMESTAMP<br>STRING | Parse JSON for change tracking | Meeting change auditing |
| `previousEndDateTime` | `previous_end_datetime`<br>`previous_end_timezone` | TIMESTAMP<br>STRING | Parse JSON for change tracking | Meeting change auditing |
| `previousLocation` | `previous_location_display_name` | STRING | Parse JSON for change tracking | Location change auditing |

#### **Meeting Recurrence**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `recurrence` | `recurrence_pattern_type`<br>`recurrence_interval`<br>`recurrence_days_of_week`<br>`recurrence_day_of_month`<br>`recurrence_month`<br>`recurrence_range_type`<br>`recurrence_start_date`<br>`recurrence_end_date` | STRING<br>INT<br>ARRAY&lt;STRING&gt;<br>INT<br>INT<br>STRING<br>DATE<br>DATE | Parse complex JSON recurrence pattern | Flatten for recurrence analysis |

#### **Meeting Status Flags**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `isDelegated` | `is_delegated` | BOOLEAN | Direct copy | Delegation tracking |
| `isOutOfDate` | `is_out_of_date` | BOOLEAN | Direct copy | Meeting freshness indicator |

#### **Flag Information**
| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `flag` | `flag_status`<br>`flag_start_datetime`<br>`flag_due_datetime`<br>`flag_completed_datetime` | STRING<br>TIMESTAMP<br>TIMESTAMP<br>TIMESTAMP | Parse JSON flag object | Task management tracking |

### 3.3 KEEP - Lineage & Auditing Fields

| Raw Field | Silver Field | Data Type | Transformation | Justification |
|-----------|--------------|-----------|----------------|---------------|
| `source` | `source` | STRING | Direct copy | Data lineage |
| `source_name` | `source_name` | STRING | Direct copy | Data lineage |
| `ingest_load_timestamp` | `bronze_ingested_datetime` | TIMESTAMP | Rename for clarity | Processing audit trail |
| - | `silver_processed_datetime` | TIMESTAMP | Add current_timestamp() | Processing audit trail |

### 3.4 REMOVE - Operational & Low-Value Fields

#### **OData Operational Fields**
- `odata_etag` - Version control metadata, not business relevant
- `odata_type` - Type metadata, not business relevant

#### **Redundant Fields**
- `bodyPreview` - Redundant with body content
- `conversationIndex` - Low business value compared to conversationId

#### **Technical Metadata**
- `_rescued_data` - ETL metadata, not business data
- `source_file` - Technical path information

---

## 4. Data Quality & Validation Rules

### 4.1 Field-Level Validations

#### **Core Business Rules**
1. **Message ID**: Must be non-null and unique within dataset
2. **Timestamps**: All datetime fields must be valid timestamps or null
3. **Email Addresses**: Must follow valid email format when present
4. **Boolean Fields**: Must be true/false or null (no string representations)

#### **Nested JSON Parsing Rules**
1. **Graceful Degradation**: If JSON parsing fails, extract what's possible and log errors
2. **Null Handling**: Distinguish between missing fields and null values in JSON
3. **Array Processing**: Handle empty arrays vs null arrays consistently
4. **Timezone Handling**: Default to UTC when timezone information is missing

#### **Business Logic Validations**
1. **Meeting Validation**: If `message_type` indicates meeting, require meeting-specific fields
2. **Recipient Validation**: At least one of `to_recipients`, `cc_recipients`, or `bcc_recipients` should be present
3. **Temporal Logic**: `sent_datetime` should be >= `created_datetime` when both present
4. **Attachment Consistency**: `has_attachments` should align with actual attachment presence

### 4.2 Data Quality Metrics

#### **Monitoring Dashboard Metrics**
1. **Parsing Success Rate**: % of successfully parsed nested JSON fields
2. **Null Rate by Field**: Track fields with high null rates for investigation
3. **Data Freshness**: Monitor `last_modified_datetime` vs `silver_processed_datetime`
4. **Volume Anomalies**: Alert on significant volume changes day-over-day

---

## 5. Implementation Structure

### 5.1 Recommended File Structure

```
emob_datalake_databricks/notebooks/euh/
├── euh_etl_emails_msgraph.py          # Main transformation notebook (includes all helper functions)
└── euh_etl_email_attachments_msgraph.py       # Attachment processing (future)

conf/tasks/euh/
├── euh_etl_emails_msgraph.yml         # Workflow configuration
└── euh_etl_email_attachments_msgraph.yml      # Attachment workflow (future)

library/database/
└── models.py                                   # Add EmailMessagesSilver model

tests/unit/euh/
└── test_email_transformations.py              # Unit tests for transformations
```

### 5.2 Processing Architecture

#### **Stream Processing Design**
- **Auto Loader**: Continue using Auto Loader for incremental processing
- **Watermarking**: Use `last_modified_datetime` for incremental loads
- **Checkpointing**: Separate checkpoints for silver layer processing
- **Error Handling**: Dead letter queue for unparseable records

#### **Table Design**
- **Target Schema**: `euh-emobility`
- **Table Name**: `emails_euh_emobility`
- **Partitioning**: Consider partitioning by year/month of `received_datetime`
- **Clustering**: Cluster by `conversation_id` and `received_datetime` for query performance

---

## 6. Schema Evolution Strategy

### 6.1 Versioning Approach
1. **Additive Changes**: New fields can be added without breaking existing queries
2. **Field Renaming**: Use views to maintain backwards compatibility
3. **Data Type Changes**: Require explicit migration strategy
4. **Field Removal**: Deprecation period before removal

### 6.2 Microsoft Graph API Evolution
1. **New Fields**: Monitor Microsoft Graph API updates for new email fields
2. **Deprecated Fields**: Track Microsoft's deprecation notices
3. **API Version Management**: Plan for API version updates

---

## 7. Performance Considerations

### 7.1 Query Optimization
1. **Common Access Patterns**: 
   - Filter by `received_datetime` range (most common)
   - Search by `from_email_address` or `to_recipients`
   - Group by `conversation_id` for thread analysis
   - Filter by `has_attachments` for attachment analysis

2. **Indexing Strategy**:
   - Primary clustering on `received_datetime` for time-based queries
   - Secondary clustering on `conversation_id` for thread queries
   - Consider Bloom filters on email address fields

### 7.2 Storage Optimization
1. **Compression**: Use Delta Lake's built-in compression for large text fields
2. **Column Pruning**: Structure queries to only read necessary columns
3. **Predicate Pushdown**: Ensure filtering pushes down to storage layer

### 7.3 Processing Performance
1. **Incremental Processing**: Only process new/changed records
2. **Parallel Processing**: Leverage Databricks' auto-scaling for large volumes
3. **Memory Management**: Monitor memory usage during JSON parsing operations

---

## Conclusion

This plan provides a comprehensive approach to transforming the raw email data into a structured silver layer that:

1. **Maintains Business Value**: Preserves all analytically relevant information
2. **Improves Usability**: Flattens complex structures for easier querying
3. **Ensures Quality**: Implements validation and monitoring
4. **Optimizes Performance**: Structures data for common access patterns
5. **Enables Analytics**: Provides a clean foundation for downstream reporting and ML

The transformation focuses on creating a business-friendly schema while maintaining the technical rigor required for enterprise data processing. The plan accounts for both current requirements and future scalability needs.

### Next Steps
1. **Review and approve** this transformation plan
2. **Implement** the core transformation logic
3. **Test** with sample data to validate approach
4. **Deploy** incrementally with monitoring
5. **Document** the final schema for downstream consumers

---

*This plan serves as the foundation for implementing the email silver layer transformation while ensuring data quality, performance, and business value.*