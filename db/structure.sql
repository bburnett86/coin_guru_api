SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: coins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coins (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    image_url character varying,
    description text,
    symbol character varying NOT NULL,
    thumb_image_url character varying,
    small_image_url character varying,
    large_image_url character varying,
    homepage character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.histories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    price double precision NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    coin_id uuid NOT NULL
);


--
-- Name: reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reasons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type character varying NOT NULL,
    suggestion_id uuid NOT NULL,
    description text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: references; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."references" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    url character varying NOT NULL,
    description text NOT NULL,
    reason_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suggestions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    coin_id uuid NOT NULL,
    suggestion_type character varying NOT NULL,
    user_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: coins coins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT coins_pkey PRIMARY KEY (id);


--
-- Name: histories histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.histories
    ADD CONSTRAINT histories_pkey PRIMARY KEY (id);


--
-- Name: reasons reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reasons
    ADD CONSTRAINT reasons_pkey PRIMARY KEY (id);


--
-- Name: references references_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."references"
    ADD CONSTRAINT references_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: suggestions suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_coins_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_coins_on_name ON public.coins USING btree (name);


--
-- Name: index_coins_on_symbol; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_coins_on_symbol ON public.coins USING btree (symbol);


--
-- Name: index_histories_on_coin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_histories_on_coin_id ON public.histories USING btree (coin_id);


--
-- Name: index_reasons_on_suggestion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reasons_on_suggestion_id ON public.reasons USING btree (suggestion_id);


--
-- Name: index_references_on_reason_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_references_on_reason_id ON public."references" USING btree (reason_id);


--
-- Name: index_suggestions_on_coin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_suggestions_on_coin_id ON public.suggestions USING btree (coin_id);


--
-- Name: index_suggestions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_suggestions_on_user_id ON public.suggestions USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_first_name ON public.users USING btree (first_name);


--
-- Name: index_users_on_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_last_name ON public.users USING btree (last_name);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: references fk_rails_1adfaf8465; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."references"
    ADD CONSTRAINT fk_rails_1adfaf8465 FOREIGN KEY (reason_id) REFERENCES public.reasons(id);


--
-- Name: reasons fk_rails_865db19d2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reasons
    ADD CONSTRAINT fk_rails_865db19d2c FOREIGN KEY (suggestion_id) REFERENCES public.suggestions(id);


--
-- Name: histories fk_rails_b41e39cfc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.histories
    ADD CONSTRAINT fk_rails_b41e39cfc1 FOREIGN KEY (coin_id) REFERENCES public.coins(id);


--
-- Name: suggestions fk_rails_e40b042562; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT fk_rails_e40b042562 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: suggestions fk_rails_fe1134aeb8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT fk_rails_fe1134aeb8 FOREIGN KEY (coin_id) REFERENCES public.coins(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250131000216'),
('20250130220926'),
('20250130220925'),
('20250130220924'),
('20250130220923'),
('20250130220922'),
('20250130220921'),
('20250130220000');

