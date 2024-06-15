-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;
-- public.addresses definition

-- Drop table

-- DROP TABLE public.addresses;

CREATE TABLE public.addresses (
  id uuid NOT NULL,
  public_place varchar(255) NULL,
  "number" varchar(11) NULL,
  neighborhood varchar(255) NULL,
  city varchar(255) NULL,
  state bpchar(2) NULL,
  cep bpchar(8) NULL,
  complement varchar(255) NULL,
  CONSTRAINT addresses_pkey PRIMARY KEY (id)
);


-- public.companies definition

-- Drop table

-- DROP TABLE public.companies;

CREATE TABLE public.companies (
  id uuid NOT NULL,
  corporate_reason varchar(255) NULL,
  cnpj bpchar(14) NULL,
  phone varchar(10) NULL,
  address_id uuid NULL,
  CONSTRAINT companies_pkey PRIMARY KEY (id),
  CONSTRAINT companies_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id)
);


-- public.product_maps_history definition

-- Drop table

-- DROP TABLE public.product_maps_history;

CREATE TABLE public.product_maps_history (
  id uuid NOT NULL,
  generated_date date NULL,
  is_original bool NULL,
  company_id uuid NULL,
  CONSTRAINT product_maps_history_pkey PRIMARY KEY (id),
  CONSTRAINT product_maps_history_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id)
);


-- public.products definition

-- Drop table

-- DROP TABLE public.products;

CREATE TABLE public.products (
  id uuid NOT NULL,
  "name" varchar(255) NULL,
  measurement_unit bpchar(2) NULL,
  company_id uuid NULL,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id)
);


-- public.suppliers definition

-- Drop table

-- DROP TABLE public.suppliers;

CREATE TABLE public.suppliers (
  id uuid NOT NULL,
  corporate_reason varchar(255) NULL,
  cnpj bpchar(14) NULL,
  phone varchar(10) NULL,
  address_id uuid NULL,
  company_id uuid NULL,
  CONSTRAINT suppliers_pkey PRIMARY KEY (id),
  CONSTRAINT suppliers_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id),
  CONSTRAINT suppliers_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id)
);


-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
  id uuid NOT NULL,
  "name" varchar(255) NULL,
  cpf bpchar(11) NULL,
  rg bpchar(9) NULL,
  phone varchar(11) NULL,
  email varchar(255) NULL,
  "password" varchar(255) NULL,
  is_active bool NULL,
  address_id uuid NULL,
  company_id uuid NULL,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id),
  CONSTRAINT users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id)
);


-- public.access_log definition

-- Drop table

-- DROP TABLE public.access_log;

CREATE TABLE public.access_log (
  id uuid NOT NULL,
  log_date timestamp NULL,
  user_id uuid NULL,
  CONSTRAINT access_log_pkey PRIMARY KEY (id),
  CONSTRAINT access_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);


-- public.invoices definition

-- Drop table

-- DROP TABLE public.invoices;

CREATE TABLE public.invoices (
  id uuid NOT NULL,
  invoice_number varchar(255) NULL,
  "path" varchar(255) NULL,
  supplier_id uuid NULL,
  registration_user_id uuid NULL,
  company_id uuid NULL,
  CONSTRAINT invoices_pkey PRIMARY KEY (id),
  CONSTRAINT invoices_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id),
  CONSTRAINT invoices_registration_user_id_fkey FOREIGN KEY (registration_user_id) REFERENCES public.users(id),
  CONSTRAINT invoices_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id)
);


-- public.product_maps_history_products definition

-- Drop table

-- DROP TABLE public.product_maps_history_products;

CREATE TABLE public.product_maps_history_products (
  id uuid NOT NULL,
  remaining_quantity numeric(12, 6) NULL,
  purchased_quantity numeric(12, 6) NULL,
  total_consumed numeric(12, 6) NULL,
  total_lost numeric(12, 6) NULL,
  final_quantity numeric(12, 6) NULL,
  product_map_history_id uuid NULL,
  product_id uuid NULL,
  CONSTRAINT product_maps_history_products_pkey PRIMARY KEY (id),
  CONSTRAINT product_maps_history_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_maps_history_products_product_map_history_id_fkey FOREIGN KEY (product_map_history_id) REFERENCES public.product_maps_history(id)
);


-- public.product_movimentations_in definition

-- Drop table

-- DROP TABLE public.product_movimentations_in;

CREATE TABLE public.product_movimentations_in (
  id uuid NOT NULL,
  quantity numeric(12, 6) NULL,
  purchase_date date NULL,
  invoice_id uuid NULL,
  product_id uuid NULL,
  supplier_id uuid NULL,
  registration_user_id uuid NULL,
  company_id uuid NULL,
  CONSTRAINT product_movimentations_in_pkey PRIMARY KEY (id),
  CONSTRAINT product_movimentations_in_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id),
  CONSTRAINT product_movimentations_in_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id),
  CONSTRAINT product_movimentations_in_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_movimentations_in_registration_user_id_fkey FOREIGN KEY (registration_user_id) REFERENCES public.users(id),
  CONSTRAINT product_movimentations_in_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id)
);


-- public.product_movimentations_out definition

-- Drop table

-- DROP TABLE public.product_movimentations_out;

CREATE TABLE public.product_movimentations_out (
  id uuid NOT NULL,
  quantity numeric(12, 6) NULL,
  destination bpchar(2) NULL,
  consumption_date timestamp NULL,
  product_id uuid NULL,
  registration_user_id uuid NULL,
  company_id uuid NULL,
  CONSTRAINT product_movimentations_out_pkey PRIMARY KEY (id),
  CONSTRAINT product_movimentations_out_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id),
  CONSTRAINT product_movimentations_out_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_movimentations_out_registration_user_id_fkey FOREIGN KEY (registration_user_id) REFERENCES public.users(id)
);