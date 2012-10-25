CREATE TYPE "balance_type_enum" AS ENUM ('user', 'community');
CREATE TYPE "community_goal_type_enum" AS ENUM ('purchase', 'petition', 'project');
CREATE TYPE "community_role_enum" AS ENUM ('organizer', 'participant', 'invitee');
CREATE TYPE "record_table_enum" AS ENUM ('transaction', 'exchange', 'transfer');
CREATE TYPE "community_goal_ledger_target_type_enum" AS ENUM ('user', 'community');
CREATE TYPE "participation_enum" AS ENUM ('opted-in', 'opted-out', 'participating', 'nonparticipating');
