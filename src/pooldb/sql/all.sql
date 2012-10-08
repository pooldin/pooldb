CREATE TABLE "user" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT False,
"verified" bool NOT NULL DEFAULT False,
"username" varchar(40) NOT NULL,
"password" varchar(255) NOT NULL,
"name" varchar(255),
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "user_username_index" ON "user" ("username");

CREATE TABLE "user_meta" (
"id" serial8 NOT NULL,
"user_id" serial8 NOT NULL,
"key" varchar(255) NOT NULL,
"value" text NOT NULL,
"create" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE INDEX "user_meda_user_id_index" ON "user_meta" ("user_id" ASC);

CREATE TABLE "balance" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"type" balance_type NOT NULL,
"user_id" serial8,
"community_id" serial8,
"currency_id" serial8 NOT NULL,
"amount" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

COMMENT ON COLUMN "balance"."type" IS 'enumerations: {''user'', ''campaign''}';

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
PRIMARY KEY ("id")
);

CREATE INDEX "balance_number_index" ON "currency" ("number");

CREATE TABLE "transaction" (
"id" uuid NOT NULL,
"balance_id" serial8,
"campaign_goal_id" serial8,
"debit" decimal(24,4) NOT NULL,
"credit" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
PRIMARY KEY ("id")
);

COMMENT ON COLUMN "transaction"."campaign_goal_id" IS 'Used to link a transaction with a specific campaign goal for auditing/analytics purposes.';

CREATE TABLE "transfer" (
"id" uuid NOT NULL,
"group_id" uuid NOT NULL,
"balance_id" serial8 NOT NULL,
"debit" decimal(24,4) NOT NULL,
"credit" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
PRIMARY KEY ("id")
);

CREATE TABLE "exchange" (
"id" uuid NOT NULL,
"debit_currency_id" serial8 NOT NULL,
"credit_currency_id" serial8 NOT NULL,
"exchane_rate" decimal(24,4) NOT NULL,
"balance_id" serial8 NOT NULL,
"debit" decimal(24,4) NOT NULL,
"credit" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
PRIMARY KEY ("id")
);

CREATE TABLE "external_ledger" (
"id" uuid NOT NULL,
"record_id" uuid NOT NULL,
"record_table" varchar(255) NOT NULL,
"party" varchar(255) NOT NULL,
"external_reference_number" varchar,
"fee_id" serial8,
"currency_id" serial8 NOT NULL,
"debit" decimal(24,4) NOT NULL,
"credit" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
PRIMARY KEY ("id")
);

CREATE TABLE "fee" (
"id" serial8 NOT NULL,
"name" varchar(64) NOT NULL,
"description" text NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
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
"community_id" serial8 NOT NULL,
"purchase_id" serial8,
"type" community_goal_type NOT NULL,
"start" timestamptz NOT NULL,
"end" timestamptz NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE TABLE "community_goal_meta" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL,
"community_goal_id" serial8 NOT NULL,
"key" varchar(255) NOT NULL,
"value" text NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE TABLE "community_goal_meta_key" (
"id" varchar(255) NOT NULL,
"enabled" bool NOT NULL,
"description" text NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE TABLE "community_association" (
"id" serial8 NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"community_id" serial8 NOT NULL,
"user_id" serial8 NOT NULL,
"role" community_role_type NOT NULL DEFAULT 'participant',
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE TABLE "invitee" (
"id" varchar(255) NOT NULL,
"enabled" bool NOT NULL DEFAULT True,
"user_id" serial8,
"campaign_id" serial8 NOT NULL,
"email" varchar(255) NOT NULL,
"accepted" timestamptz,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

COMMENT ON COLUMN "invitee"."id" IS 'Composed of sha1(email + campaign_id) to uniquely identify an invitation.';

CREATE TABLE "internal_ledger" (
"id" uuid NOT NULL,
"record_id" uuid NOT NULL,
"record_table" varchar(255) NOT NULL,
"party" varchar(255) NOT NULL,
"fee_id" serial8,
"currency_id" serial8 NOT NULL,
"debit" decimal(24,4) NOT NULL,
"credit" decimal(24,4) NOT NULL,
"created" timestamptz NOT NULL,
"remote_ip" cidr NOT NULL,
PRIMARY KEY ("id")
);

CREATE TABLE "purchase" (
"id" serial8 NOT NULL,
"name" varchar(255) NOT NULL,
"description" varchar(255) NOT NULL,
"purchase_ledger_id" uuid NOT NULL,
"fulfilled" bool NOT NULL DEFAULT False,
"refunded" bool NOT NULL DEFAULT False,
"refund_ledger_id" uuid,
"address_one" varchar(255),
"address_two" varchar(255),
"city" varchar(255),
"state" varchar(4),
"country" varchar(32),
"zip" varchar(255),
"email" varchar(255) NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

CREATE TABLE "user_purchase" (
"id" serial8 NOT NULL,
"user_id" serial8 NOT NULL,
"purchase_id" serial8 NOT NULL,
"created" timestamptz NOT NULL,
"modified" timestamptz NOT NULL,
"remote_ip" cidr,
PRIMARY KEY ("id")
);

ALTER TABLE "user_meta" ADD CONSTRAINT "a4_user_meta_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "balance" ADD CONSTRAINT "a4_balance_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "balance" ADD CONSTRAINT "a4_balance_currency_id_fk" FOREIGN KEY ("currency_id") REFERENCES "currency" ("id");
ALTER TABLE "transfer" ADD CONSTRAINT "a4_transfer_balance_id_fk" FOREIGN KEY ("balance_id") REFERENCES "balance" ("id");
ALTER TABLE "exchange" ADD CONSTRAINT "a4_exchange_balance_id_fk" FOREIGN KEY ("balance_id") REFERENCES "balance" ("id");
ALTER TABLE "transaction" ADD CONSTRAINT "a4_transaction_balance_id_fk" FOREIGN KEY ("balance_id") REFERENCES "balance" ("id");
ALTER TABLE "community_goal" ADD CONSTRAINT "a4_community_goal_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_goal_meta" ADD CONSTRAINT "a4_community_meta_key_community_goal_id_fk" FOREIGN KEY ("community_goal_id") REFERENCES "community_goal" ("id");
ALTER TABLE "community_goal_meta" ADD CONSTRAINT "a4_community_meta_key_community_goal_meta_key_key_fk" FOREIGN KEY ("key") REFERENCES "community_goal_meta_key" ("id");
ALTER TABLE "balance" ADD CONSTRAINT "a4_balance_campaign_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_association" ADD CONSTRAINT "a4_community_association_community_id_fk" FOREIGN KEY ("community_id") REFERENCES "community" ("id");
ALTER TABLE "community_association" ADD CONSTRAINT "a4_community_association_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "invitee" ADD CONSTRAINT "a4_invitee_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "invitee" ADD CONSTRAINT "a4_invitee_community_id_fk" FOREIGN KEY ("campaign_id") REFERENCES "community" ("id");
ALTER TABLE "exchange" ADD CONSTRAINT "a4_exchange_debit_currency_id_fk" FOREIGN KEY ("debit_currency_id") REFERENCES "currency" ("id");
ALTER TABLE "external_ledger" ADD CONSTRAINT "a4_external_ledger_fee_id_fk" FOREIGN KEY ("fee_id") REFERENCES "fee" ("id");
ALTER TABLE "external_ledger" ADD CONSTRAINT "a4_external_ledger_currency_id" FOREIGN KEY ("currency_id") REFERENCES "currency" ("id");
ALTER TABLE "internal_ledger" ADD CONSTRAINT "a4_internal_ledger_fee_id_fk" FOREIGN KEY ("fee_id") REFERENCES "fee" ("id");
ALTER TABLE "internal_ledger" ADD CONSTRAINT "a4_internal_ledger_currency_id_fk" FOREIGN KEY ("currency_id") REFERENCES "currency" ("id");
ALTER TABLE "exchange" ADD CONSTRAINT "a4_exchange_credit_currency_id_fk" FOREIGN KEY ("credit_currency_id") REFERENCES "currency" ("id");
ALTER TABLE "community_goal" ADD CONSTRAINT "a4_community_goal_purchases_id_fk" FOREIGN KEY ("purchase_id") REFERENCES "purchase" ("id");
ALTER TABLE "user_purchase" ADD CONSTRAINT "a4_user_purchase_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "user" ("id");
ALTER TABLE "user_purchase" ADD CONSTRAINT "a4_user_purchase_purchase_id_fk" FOREIGN KEY ("purchase_id") REFERENCES "purchase" ("id");
ALTER TABLE "purchase" ADD CONSTRAINT "a4_purchase_refund_external_ledger_id_fk" FOREIGN KEY ("refund_ledger_id") REFERENCES "external_ledger" ("id");
ALTER TABLE "purchase" ADD CONSTRAINT "a4_purchase_purchase_external_ledger_id_fk" FOREIGN KEY ("purchase_ledger_id") REFERENCES "external_ledger" ("id");
