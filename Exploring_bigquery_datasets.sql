
-- Selecting 100 rows ----
SELECT * 
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
LIMIT 100;

-- Creating new table ----
CREATE TABLE `data-fabric-458308-k2.test_dataset.looker_notes` AS
SELECT description, published_at, product_version_name
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
WHERE product_name = 'Looker';

--- Exploring new table ----
SELECT * FROM `data-fabric-458308-k2.test_dataset.looker_notes`
LIMIT 100;

SELECT product_version_name, COUNT(*)
FROM `data-fabric-458308-k2.test_dataset.looker_notes`
GROUP BY product_version_name;

--- Updating records in the new table ------
UPDATE `data-fabric-458308-k2.test_dataset.looker_notes`
SET product_version_name = 'Looker (Google Cloud core) & Looker (original) changes'
WHERE product_version_name = 'Looker (Google Cloud core) and Looker (original) changes';

--- Deleting records in the new table -----
DELETE FROM `data-fabric-458308-k2.test_dataset.looker_notes`
WHERE product_version_name = 'Looker (Google Cloud core) only changes';

--- Viewing records before they were deleted ----
SELECT product_version_name, COUNT(*)
FROM `data-fabric-458308-k2.test_dataset.looker_notes`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 5 MINUTE)
GROUP BY product_version_name;

--- Fetching deleted records ---
SELECT *
FROM `data-fabric-458308-k2.test_dataset.looker_notes`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 10 MINUTE)
WHERE product_version_name = 'Looker (Google Cloud core) only changes';

--- Creating new table to insert the deleted records ----
CREATE TABLE `data-fabric-458308-k2.test_dataset.looker_notes_recover` AS
SELECT *
FROM `data-fabric-458308-k2.test_dataset.looker_notes`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 15 MINUTE)
WHERE product_version_name = 'Looker (Google Cloud core) only changes';

--- Inserting the deleted records back to the original table ----
INSERT INTO `data-fabric-458308-k2.test_dataset.looker_notes`
SELECT * FROM `data-fabric-458308-k2.test_dataset.looker_notes_recover`;












