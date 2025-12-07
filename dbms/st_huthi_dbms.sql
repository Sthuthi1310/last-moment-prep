-- ============================================================
-- STUDY TRACKER DATABASE - DBMS PROJECT SQL SCRIPT
-- Author: Sthuthi
-- File: st_huthi_dbms.sql
-- ============================================================


-- ===========================
-- 🔥 TRIGGERS SECTION
-- ===========================

-- 1️⃣ Trigger: Auto insert into progress after new concept is added
DELIMITER $$

CREATE TRIGGER trg_after_insert_concept
AFTER INSERT ON concept
FOR EACH ROW
BEGIN
    INSERT INTO progress (concept_id, status, last_updated)
    VALUES (NEW.concept_id, 'Not Started', NOW());
END$$

DELIMITER ;


-- 2️⃣ Trigger: Auto update timestamp when progress status changes
DELIMITER $$

CREATE TRIGGER trg_before_update_progress
BEFORE UPDATE ON progress
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        SET NEW.last_updated = NOW();
    END IF;
END$$

DELIMITER ;


-- 3️⃣ Trigger: Auto create revision entry when a concept is updated
DELIMITER $$

CREATE TRIGGER trg_after_update_concept
AFTER UPDATE ON concept
FOR EACH ROW
BEGIN
    INSERT INTO revision_log (concept_id, revision_time)
    VALUES (NEW.concept_id, NOW());
END$$

DELIMITER ;



-- ===========================
-- ⚙ STORED PROCEDURES SECTION
-- ===========================

-- 1️⃣ Add a new concept
DELIMITER $$

CREATE PROCEDURE sp_add_concept(
    IN p_concept_id INT,
    IN p_subject_id INT,
    IN p_concept_name VARCHAR(100),
    IN p_importance VARCHAR(20)
)
BEGIN
    INSERT INTO concept (concept_id, subject_id, concept_name, importance)
    VALUES (p_concept_id, p_subject_id, p_concept_name, p_importance);
END$$

DELIMITER ;


-- 2️⃣ Update progress status
DELIMITER $$

CREATE PROCEDURE sp_update_progress(
    IN p_concept_id INT,
    IN p_status VARCHAR(50)
)
BEGIN
    UPDATE progress
    SET status = p_status
    WHERE concept_id = p_concept_id;
END$$

DELIMITER ;


-- 3️⃣ Get revision history of a concept
DELIMITER $$

CREATE PROCEDURE sp_get_revision_history(
    IN p_concept_id INT
)
BEGIN
    SELECT revision_time
    FROM revision_log
    WHERE concept_id = p_concept_id
    ORDER BY revision_time DESC;
END$$

DELIMITER ;



-- ===========================
-- 🔁 TRANSACTION EXAMPLES
-- ===========================


-- 1️⃣ ROLLBACK Example
START TRANSACTION;

UPDATE progress
SET status = 'Completed'
WHERE concept_id = 30;

ROLLBACK;



-- 2️⃣ COMMIT Example
START TRANSACTION;

UPDATE progress
SET status = 'Completed'
WHERE concept_id = 30;

COMMIT;



-- 3️⃣ SAVEPOINT Example
START TRANSACTION;

UPDATE progress
SET status = 'In Progress'
WHERE concept_id = 30;

SAVEPOINT sp1;

UPDATE progress
SET status = 'Completed'
WHERE concept_id = 30;

ROLLBACK TO sp1;

COMMIT;


-- ============================================================
-- END OF SCRIPT
-- ============================================================
