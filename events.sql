DROP TABLE IF EXISTS event_cancellations CASCADE;
DROP TABLE IF EXISTS event_recurrences CASCADE;
DROP TABLE IF EXISTS events CASCADE;

DROP DOMAIN IF EXISTS frequency CASCADE;
CREATE DOMAIN frequency AS CHARACTER VARYING CHECK ( VALUE IN ( 'once', 'daily', 'weekly', 'monthly', 'yearly' ) );

CREATE TABLE events (
  id serial PRIMARY KEY,
  starts_on date,
  ends_on date,
  starts_at timestamp without time zone,
  ends_at timestamp without time zone,
  frequency frequency,
  separation integer not null default 1 constraint positive_separation check (separation > 0),
  count integer,
  "until" date,
  timezone_name text not null default 'Etc/UTC',
  status integer not null default 1
);

CREATE TABLE event_recurrences (
  id serial PRIMARY KEY,
  event_id integer,
  "month" integer,
  "day" integer,
  week integer
);
ALTER TABLE event_recurrences ADD CONSTRAINT event FOREIGN KEY (event_id) REFERENCES events (id);

CREATE TABLE event_cancellations (
  id serial PRIMARY KEY,
  event_id integer,
  date date
);
ALTER TABLE event_cancellations ADD CONSTRAINT event FOREIGN KEY (event_id) REFERENCES events (id);
