# Export Auth, Database and Storage data

When migrating or exporting data from a Supabase project, there are several available approaches. Each option has its own advantages and trade-offs depending on your use case.

---

# Option 1: Manual Export (Recommended for Individual Data)

This is the simplest and most straightforward method if you only need the project data.

## Authentication (`auth` schema)

1. Open the **Supabase Dashboard**.
2. Navigate to **SQL Editor**.
3. Execute the following query:

```sql
SELECT * FROM auth.users;
```

4. Export the returned data (Export **CSV** and **SQL**).

### Notes

* Importing `auth.users` into another project is **not automatic**.
* User records must be inserted manually.
* Password hashes cannot be reused normally, so users will need to reset or recreate their passwords.
* New user UUIDs may require updating any related foreign keys in the `public` schema.

---

## Database (`public` schema)

For each table, either:

### Option A

Run:

```sql
SELECT * FROM public.table_name;
```

Then export the results.

### Option B (Recommended)

1. Go to **Table Editor**.
2. Select the desired table.
3. Click the **three dots (⋮)** choose **Export**.

We recommend exporting each table in both:

* CSV format
* SQL format

---

## Storage

1. Open the **Storage** section.
2. Select folder of the school.
3. Click the **three dots (⋮)** then choose **Export**.

Files will be exported as .zip file

---

# Option 2: Clone the Entire Project

This option is best when creating another Supabase project for development, testing, or staging.

You can use:

* https://supabaseclone.com/

The tool requires information such as:

* Access Token
* Database Password
* Project Reference
* Other project credentials

### Advantages

* Copies almost the entire project.
* Much faster than manually exporting every table.
* Great for creating development or testing environments.

### Limitations

* It clones the entire project rather than exporting individual datasets.
* Not intended for selective data migration.

---

# Option 3: Supabase CLI

Another migration option is using the **Supabase CLI**.

> **Note:** We have not used this approach yet, so we cannot comment on its limitations or trade-offs.

### Prerequisites

Before using the CLI, you may need to install:

* Docker Desktop
* Node.js (npm)
* Supabase CLI
* Any additional dependencies required by your operating system

This method provides more flexibility but also requires more setup compared to the previous options.
