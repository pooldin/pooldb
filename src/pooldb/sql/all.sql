CREATE TABLE "user" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"verified" bool NOT NULL DEFAULT False,
"username" varchar(40) NOT NULL,
"password" varchar(64) NOT NULL,
"name" varchar(255),
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE UNIQUE INDEX "user_username_index" ON "user" ("username");

CREATE TABLE "user_meta" (
"id" serial8 NOT NULL,
"user_id" int8 NOT NULL,
"key" varchar(255) NOT NULL,
"value" text NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE INDEX "user_meda_user_id_key_index" ON "user_meta" ("user_id" ASC, "key" ASC);

CREATE TABLE "balance" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"type" balance_type_enum NOT NULL,
"user_id" int8,
"community_id" int8,
"currency_id" int8 NOT NULL,
"amount" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

COMMENT ON COLUMN "balance"."type" IS 'enumerations: [''user'', ''community'']';

CREATE TABLE "currency" (
"id" serial8 NOT NULL,
"title" varchar(128) NOT NULL,
"code" varchar(4) NOT NULL,
"number" int4 NOT NULL,
"unit" varchar(32) NOT NULL,
"unit_plural" varchar(32) NOT NULL,
"sign" varchar(1) NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE INDEX "balance_number_index" ON "currency" ("number");

CREATE TABLE "transaction" (
"id" uuid NOT NULL,
"balance_id" int8,
"community_goal_id" int8,
"debit" decimal(24,4),
"credit" decimal(24,4),
"created" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

COMMENT ON COLUMN "transaction"."community_goal_id" IS 'Used to link a transaction with a specific community goal for auditing/analytics purposes.';

CREATE TABLE "transfer" (
"id" uuid NOT NULL,
"group_id" uuid NOT NULL,
"balance_id" int8 NOT NULL,
"debit" decimal(24,4),
"credit" decimal(24,4),
"created" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE TABLE "exchange" (
"id" uuid NOT NULL,
"debit_currency_id" int8 NOT NULL,
"credit_currency_id" int8 NOT NULL,
"exchane_rate" decimal(24,4) NOT NULL,
"balance_id" int8 NOT NULL,
"debit" decimal(24,4),
"credit" decimal(24,4),
"created" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
PRIMARY KEY ("id") 
);

CREATE TABLE "external_ledger" (
"id" uuid NOT NULL,
"record_id" uuid NOT NULL,
"record_table" record_table_enum NOT NULL,
"party" varchar(255) NOT NULL,
"external_reference_number" varchar(255),
"fee_id" int8,
"currency_id" int8 NOT NULL,
"debit" decimal(24,4),
"credit" decimal(24,4),
"created" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

COMMENT ON COLUMN "external_ledger"."record_table" IS 'enumerations: [''transaction'', ''exchange'', ''transfer'']';

CREATE TABLE "fee" (
"id" serial8 NOT NULL,
"name" varchar(64) NOT NULL,
"description" text NOT NULL,
"percentage" decimal(5,4) NOT NULL DEFAULT Decimal('0.0000'),
"flat" decimal(8,4) NOT NULL DEFAULT Decimal('0.0000'),
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
"enabled" bool NOT NULL DEFAULT True,
PRIMARY KEY ("id") 
);

CREATE TABLE "community" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"name" varchar(255) NOT NULL,
"description" text NOT NULL,
"start" timestamptz NOT NULL,
"end" timestamptz,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE TABLE "community_goal" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"community_id" int8 NOT NULL,
"purchase_id" int8,
"type" community_goal_type_enum NOT NULL,
"start" timestamptz NOT NULL,
"end" timestamptz,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
"name" varchar(255) NOT NULL,
"description" text NOT NULL,
PRIMARY KEY ("id") 
);

COMMENT ON COLUMN "community_goal"."type" IS 'enumerations: [''purchase'', ''petition'']';

CREATE TABLE "community_goal_meta" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL,
"community_goal_id" int8 NOT NULL,
"key" varchar(255) NOT NULL,
"value" text NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE TABLE "community_goal_meta_key" (
"id" serial8 NOT NULL,
"key" varchar(255) NOT NULL,
"enabled" bool NOT NULL,
"description" text NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
CONSTRAINT "id" PRIMARY KEY ("id", "key") ,
UNIQUE ("key")
);

CREATE TABLE "community_association" (
"enabled" bool NOT NULL DEFAULT True,
"community_id" int8 NOT NULL,
"user_id" int8 NOT NULL,
"role" community_role_enum NOT NULL DEFAULT 'participant',
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("community_id", "user_id") 
);

CREATE TABLE "invitee" (
"id" uuid NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"user_id" int8,
"community_id" int8 NOT NULL,
"email" varchar(255) NOT NULL,
"accepted" timestamptz,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE INDEX "invitee_email_index" ON "invitee" ("email" ASC);

CREATE TABLE "internal_ledger" (
"id" uuid NOT NULL,
"record_id" uuid NOT NULL,
"record_table" varchar(255) NOT NULL,
"party" varchar(255) NOT NULL,
"fee_id" int8,
"currency_id" int8 NOT NULL,
"debit" decimal(24,4),
"credit" decimal(24,4),
"created" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE TABLE "purchase" (
"id" serial8 NOT NULL,
"name" varchar(255) NOT NULL,
"description" text NOT NULL,
"purchase_ledger_id" uuid NOT NULL,
"fulfilled" bool NOT NULL DEFAULT False,
"refunded" bool NOT NULL DEFAULT False,
"refund_ledger_id" uuid,
"address_one" varchar(255),
"address_two" varchar(255),
"city" varchar(255),
"state" varchar(4),
"country" varchar(255),
"zip" varchar(32),
"email" varchar(255) NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id") 
);

CREATE INDEX "purchase_email_index" ON "purchase" ("email" ASC);

CREATE TABLE "user_purchase" (
"id" serial8 NOT NULL,
"user_id" int8 NOT NULL,
"purchase_id" int8 NOT NULL,
PRIMARY KEY ("id") 
);

COMMENT ON TABLE "user_purchase" IS 'This is unabashedly a bare-bones through table. ''nuff said.';

CREATE TABLE "community_goal_ledger" (
"id" uuid NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
"community_id" int8 NOT NULL,
"community_goal_id" int8 NOT NULL,
"party_type" community_goal_ledger_target_type_enum NOT NULL,
"party_id" int8 NOT NULL,
"debit" decimal(24,4),
"credit" decimal(24,4),
PRIMARY KEY ("id") 
);

CREATE INDEX "community_goal_ledger_community_goal_id_index" ON "community_goal_ledger" ("community_goal_id" ASC);
CREATE INDEX "community_goal_ledger_community_id_index" ON "community_goal_ledger" ("community_id" ASC);
CREATE INDEX "community_goal_ledger_party_type_index" ON "community_goal_ledger" ("party_type" ASC);
CREATE INDEX "community_goal_ledger_party_id_index" ON "community_goal_ledger" ("party_id" ASC);
COMMENT ON COLUMN "community_goal_ledger"."party_type" IS 'party_type_enum: ''user'', ''community''';
COMMENT ON COLUMN "community_goal_ledger"."party_id" IS 'The id of the target user/community.  Not constrained by foreign keys.';

CREATE TABLE "community_goal_association" (
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
"user_id" int8 NOT NULL,
"community_id" int8 NOT NULL,
"community_goal_id" int8 NOT NULL,
"participation" participation_enum,
PRIMARY KEY ("community_id", "user_id", "community_goal_id") 
);

CREATE INDEX "community_goal_association_community_id_index" ON "community_goal_association" ("community_id" ASC);
CREATE INDEX "community_goal_association_community_goal_id_index" ON "community_goal_association" ("community_goal_id" ASC);
CREATE INDEX "community_goal_association_user_id_index" ON "community_goal_association" ("user_id" ASC);
COMMENT ON COLUMN "community_goal_association"."participation" IS 'participation_enum values: ''opted-in'', ''opted-out'', ''participating'', ''nonparticipating''. ''participating'' -> ''opted-out'' && ''nonparticipating -> ''opted-in''';


ALTER TABLE "user_meta" ADD CONSTRAINT "user_meta_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "balance" ADD CONSTRAINT "balance_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "balance" ADD CONSTRAINT "balance_currency_id_fk" FOREIGN KEY ("currency_id") REFERENCES "currency" ("id");
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_balance_id_fk" FOREIGN KEY ("balance_id") REFERENCES "balance" ("id");
ALTER TABLE "exchange" ADD CONSTRAINT "exchange_balance_id_fk" FOREIGN KEY ("balance_id") REFERENCES "balance" ("id");
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_balance_id_fk" FOREIGN KEY ("balance_id") REFERENCES "balance" ("id");
ALTER TABLE "community_goal" ADD CONSTRAINT "community_goal_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_goal_meta" ADD CONSTRAINT "community_meta_key_community_goal_id_fk" FOREIGN KEY ("community_goal_id") REFERENCES "community_goal" ("id");
ALTER TABLE "balance" ADD CONSTRAINT "balance_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_association" ADD CONSTRAINT "community_association_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_association" ADD CONSTRAINT "community_association_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "invitee" ADD CONSTRAINT "invitee_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "invitee" ADD CONSTRAINT "invitee_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "exchange" ADD CONSTRAINT "exchange_debit_currency_id_fk" FOREIGN KEY ("debit_currency_id") REFERENCES "currency" ("id");
ALTER TABLE "external_ledger" ADD CONSTRAINT "external_ledger_fee_id_fk" FOREIGN KEY ("fee_id") REFERENCES "fee" ("id");
ALTER TABLE "external_ledger" ADD CONSTRAINT "external_ledger_currency_id" FOREIGN KEY ("currency_id") REFERENCES "currency" ("id");
ALTER TABLE "internal_ledger" ADD CONSTRAINT "internal_ledger_fee_id_fk" FOREIGN KEY ("fee_id") REFERENCES "fee" ("id");
ALTER TABLE "internal_ledger" ADD CONSTRAINT "internal_ledger_currency_id_fk" FOREIGN KEY ("currency_id") REFERENCES "currency" ("id");
ALTER TABLE "exchange" ADD CONSTRAINT "exchange_credit_currency_id_fk" FOREIGN KEY ("credit_currency_id") REFERENCES "currency" ("id");
ALTER TABLE "community_goal" ADD CONSTRAINT "community_goal_purchases_id_fk" FOREIGN KEY ("purchase_id") REFERENCES "purchase" ("id");
ALTER TABLE "user_purchase" ADD CONSTRAINT "user_purchase_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "user_purchase" ADD CONSTRAINT "user_purchase_purchase_id_fk" FOREIGN KEY ("purchase_id") REFERENCES "purchase" ("id");
ALTER TABLE "purchase" ADD CONSTRAINT "purchase_refund_external_ledger_id_fk" FOREIGN KEY ("refund_ledger_id") REFERENCES "external_ledger" ("id");
ALTER TABLE "purchase" ADD CONSTRAINT "purchase_purchase_external_ledger_id_fk" FOREIGN KEY ("purchase_ledger_id") REFERENCES "external_ledger" ("id");
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_community_goal_id_fk" FOREIGN KEY ("community_goal_id") REFERENCES "community_goal" ("id");
ALTER TABLE "community_goal_ledger" ADD CONSTRAINT "community_goal_ledger_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_goal_ledger" ADD CONSTRAINT "community_goal_ledger_community_goal_id_fk" FOREIGN KEY ("community_goal_id") REFERENCES "community_goal" ("id");
ALTER TABLE "community_goal_association" ADD CONSTRAINT "community_goal_association_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_goal_association" ADD CONSTRAINT "community_goal_association_community_goal_id_fk" FOREIGN KEY ("community_goal_id") REFERENCES "community_goal" ("id");
ALTER TABLE "community_goal_association" ADD CONSTRAINT "community_goal_association_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");

