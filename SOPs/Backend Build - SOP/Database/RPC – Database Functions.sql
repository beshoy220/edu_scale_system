-- WELCOME TO EDU-SCALE DATABASE HELPER SQL FUNCTIONS (RPCs)
-- THIS FUNCTIONS are FOR 1.0.2 VERSION


-- ===============================================
--  COMPETITION STATISTICS [ADMIN ROLE]
-- ===============================================

CREATE OR REPLACE FUNCTION get_competition_statistics_json(
    p_school_id BIGINT DEFAULT NULL,
    p_start_date TIMESTAMPTZ DEFAULT NULL,
    p_end_date TIMESTAMPTZ DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSONB;
BEGIN
    WITH filtered_submissions AS (
        SELECT *
        FROM competition_student_submissions
        WHERE (p_school_id IS NULL OR school_id = p_school_id)
          AND (p_start_date IS NULL OR created_at >= p_start_date)
          AND (p_end_date IS NULL OR created_at <= p_end_date)
    ),
    unique_students AS (
        SELECT COUNT(DISTINCT student_id) as count
        FROM filtered_submissions
    ),
    grade_breakdown AS (
        SELECT jsonb_object_agg(grade_id::TEXT, submission_count) as data
        FROM (
            SELECT grade_id, COUNT(*) as submission_count
            FROM filtered_submissions
            GROUP BY grade_id
            ORDER BY grade_id
        ) sub
    ),
    competition_types AS (
        SELECT 
            COUNT(DISTINCT CASE WHEN c.type = 'solo' THEN c.id END) as solo_count,
            COUNT(DISTINCT CASE WHEN c.type = 'team' THEN c.id END) as team_count
        FROM competitions c
        INNER JOIN filtered_submissions fs ON c.id = fs.competition_id
    ),
    total_count AS (
        SELECT COUNT(*) as count FROM filtered_submissions
    )
    SELECT jsonb_build_object(
        'total_unique_students', (SELECT count FROM unique_students),
        'submissions_by_grade', COALESCE((SELECT data FROM grade_breakdown), '{}'::jsonb),
        'total_solo_competitions', (SELECT solo_count FROM competition_types),
        'total_team_competitions', (SELECT team_count FROM competition_types),
        'total_submissions', (SELECT count FROM total_count),
        'filters', jsonb_build_object(
            'school_id', p_school_id,
            'start_date', p_start_date,
            'end_date', p_end_date
        )
    ) INTO result;

    RETURN result;
END;
$$;



-- ===============================================
--  QUIZ STATISTICS [ADMIN ROLE]
-- ===============================================

CREATE OR REPLACE FUNCTION get_quiz_statistics_json(
    p_school_id BIGINT DEFAULT NULL,
    p_start_date TIMESTAMPTZ DEFAULT NULL,
    p_end_date TIMESTAMPTZ DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSONB;
BEGIN
    -- If no school_id provided, return empty stats (or you could return all, but we'll return empty)
    IF p_school_id IS NULL THEN
        RETURN jsonb_build_object(
            'total_submissions', 0,
            'submissions_by_grade', '{}'::jsonb,
            'published_quizzes', 0,
            'unpublished_quizzes', 0,
            'filters', jsonb_build_object(
                'school_id', p_school_id,
                'start_date', p_start_date,
                'end_date', p_end_date
            )
        );
    END IF;

    WITH filtered_submissions AS (
        -- Directly filter by school_id on the submissions table (denormalized)
        SELECT qss.*, q.grade_id
        FROM quiz_student_submissions qss
        JOIN quizzes q ON qss.quiz_id = q.id
        WHERE qss.school_id = p_school_id
          AND (p_start_date IS NULL OR qss.created_at >= p_start_date)
          AND (p_end_date IS NULL OR qss.created_at <= p_end_date)
    ),
    total_submissions_cte AS (
        SELECT COUNT(*) as count
        FROM filtered_submissions
    ),
    submissions_by_grade_cte AS (
        SELECT jsonb_object_agg(grade_name, submission_count) as data
        FROM (
            SELECT g.name AS grade_name, COUNT(*) AS submission_count
            FROM filtered_submissions fs
            JOIN grades g ON fs.grade_id = g.id
            GROUP BY g.name
            ORDER BY g.name
        ) sub
    ),
    published_counts AS (
        SELECT COUNT(*) as count
        FROM quizzes
        WHERE school_id = p_school_id
          AND publish_status = 'published'
    ),
    unpublished_counts AS (
        SELECT COUNT(*) as count
        FROM quizzes
        WHERE school_id = p_school_id
          AND publish_status = 'unpublished'
    )
    SELECT jsonb_build_object(
        'total_submissions', (SELECT count FROM total_submissions_cte),
        'submissions_by_grade', COALESCE((SELECT data FROM submissions_by_grade_cte), '{}'::jsonb),
        'published_quizzes', (SELECT count FROM published_counts),
        'unpublished_quizzes', (SELECT count FROM unpublished_counts),
        'filters', jsonb_build_object(
            'school_id', p_school_id,
            'start_date', p_start_date,
            'end_date', p_end_date
        )
    ) INTO result;

    RETURN result;
END;
$$;



-- ===============================================
--  ASSIGNMENT STATISTICS [ADMIN ROLE]
-- ===============================================

CREATE OR REPLACE FUNCTION get_assignments_statistics_json(
    p_school_id BIGINT DEFAULT NULL,
    p_start_date TIMESTAMPTZ DEFAULT NULL,
    p_end_date TIMESTAMPTZ DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSONB;
BEGIN
    -- If no school_id provided, return empty stats
    IF p_school_id IS NULL THEN
        RETURN jsonb_build_object(
            'total_submissions', 0,
            'submissions_by_grade', '{}'::jsonb,
            'published_assignments', 0,
            'unpublished_assignments', 0,
            'filters', jsonb_build_object(
                'school_id', p_school_id,
                'start_date', p_start_date,
                'end_date', p_end_date
            )
        );
    END IF;

    WITH filtered_submissions AS (
        SELECT ass.*, a.grade_id
        FROM assignment_student_submissions ass
        JOIN assignments a ON ass.assignment_id = a.id
        WHERE ass.school_id = p_school_id
          AND (p_start_date IS NULL OR ass.created_at >= p_start_date)
          AND (p_end_date IS NULL OR ass.created_at <= p_end_date)
    ),
    total_submissions_cte AS (
        SELECT COUNT(*) as count
        FROM filtered_submissions
    ),
    submissions_by_grade_cte AS (
        SELECT jsonb_object_agg(grade_name, submission_count) as data
        FROM (
            SELECT g.name AS grade_name, COUNT(*) AS submission_count
            FROM filtered_submissions fs
            JOIN grades g ON fs.grade_id = g.id
            GROUP BY g.name
            ORDER BY g.name
        ) sub
    ),
    published_counts AS (
        SELECT COUNT(*) as count
        FROM assignments
        WHERE school_id = p_school_id
          AND publish_status = 'published'
    ),
    unpublished_counts AS (
        SELECT COUNT(*) as count
        FROM assignments
        WHERE school_id = p_school_id
          AND publish_status = 'unpublished'
    )
    SELECT jsonb_build_object(
        'total_submissions', (SELECT count FROM total_submissions_cte),
        'submissions_by_grade', COALESCE((SELECT data FROM submissions_by_grade_cte), '{}'::jsonb),
        'published_assignments', (SELECT count FROM published_counts),
        'unpublished_assignments', (SELECT count FROM unpublished_counts),
        'filters', jsonb_build_object(
            'school_id', p_school_id,
            'start_date', p_start_date,
            'end_date', p_end_date
        )
    ) INTO result;

    RETURN result;
END;
$$;



-- ===============================================
--  ATTENDACE STATISTICS [ADMIN ROLE]
-- ===============================================

CREATE OR REPLACE FUNCTION get_attendance_statistics_json(
    school_id_param BIGINT,
    start_date DATE DEFAULT NULL,
    end_date DATE DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    total_records BIGINT;
    present_count BIGINT;
    absent_count BIGINT;
    late_count BIGINT;
    excused_count BIGINT;
    overall_json JSONB;
    by_day_json JSONB;
    by_grade_json JSONB;
BEGIN
    -- 1. Overall counts within the date range (if provided)
    SELECT
        COUNT(*) FILTER (WHERE status = 'present') AS present_count,
        COUNT(*) FILTER (WHERE status = 'absent') AS absent_count,
        COUNT(*) FILTER (WHERE status = 'late') AS late_count,
        COUNT(*) FILTER (WHERE status = 'excused') AS excused_count,
        COUNT(*) AS total_records
    INTO
        present_count, absent_count, late_count, excused_count, total_records
    FROM attendance
    WHERE school_id = school_id_param
        AND (start_date IS NULL OR attendance_date >= start_date)
        AND (end_date IS NULL OR attendance_date <= end_date);

    -- 2. Build overall percentages (if no records, all percentages are 0)
    overall_json := JSONB_BUILD_OBJECT(
        'present_percentage',
        CASE WHEN total_records > 0 THEN ROUND((present_count * 100.0) / total_records, 2) ELSE 0 END,
        'absent_percentage',
        CASE WHEN total_records > 0 THEN ROUND((absent_count * 100.0) / total_records, 2) ELSE 0 END,
        'late_percentage',
        CASE WHEN total_records > 0 THEN ROUND((late_count * 100.0) / total_records, 2) ELSE 0 END,
        'excused_percentage',
        CASE WHEN total_records > 0 THEN ROUND((excused_count * 100.0) / total_records, 2) ELSE 0 END
    );

    -- 3. Attendance by day of week (3‑letter abbreviation, e.g. 'mon', 'tue')
    WITH day_agg AS (
        SELECT
            LOWER(TO_CHAR(attendance_date, 'dy')) AS day_name,
            status,
            COUNT(*) AS cnt
        FROM attendance
        WHERE school_id = school_id_param
            AND (start_date IS NULL OR attendance_date >= start_date)
            AND (end_date IS NULL OR attendance_date <= end_date)
        GROUP BY day_name, status
    )
    SELECT COALESCE(
        JSONB_OBJECT_AGG(
            day_name,
            JSONB_BUILD_OBJECT(
                'present', COALESCE((cnt_map->>'present')::INT, 0),
                'absent',  COALESCE((cnt_map->>'absent')::INT, 0),
                'late',    COALESCE((cnt_map->>'late')::INT, 0),
                'excused', COALESCE((cnt_map->>'excused')::INT, 0)
            )
        ),
        '{}'::JSONB
    )
    INTO by_day_json
    FROM (
        SELECT
            day_name,
            JSONB_OBJECT_AGG(status, cnt) AS cnt_map
        FROM day_agg
        GROUP BY day_name
    ) sub;

    -- 4. Attendance by grade (using the grades table)
    WITH grade_agg AS (
        SELECT
            g.name AS grade_name,
            a.status,
            COUNT(*) AS cnt
        FROM attendance a
        JOIN grades g ON a.grade_id = g.id
        WHERE a.school_id = school_id_param
            AND (start_date IS NULL OR a.attendance_date >= start_date)
            AND (end_date IS NULL OR a.attendance_date <= end_date)
        GROUP BY g.name, a.status
    )
    SELECT COALESCE(
        JSONB_OBJECT_AGG(
            grade_name,
            JSONB_BUILD_OBJECT(
                'present', COALESCE((cnt_map->>'present')::INT, 0),
                'absent',  COALESCE((cnt_map->>'absent')::INT, 0),
                'late',    COALESCE((cnt_map->>'late')::INT, 0),
                'excused', COALESCE((cnt_map->>'excused')::INT, 0)
            )
        ),
        '{}'::JSONB
    )
    INTO by_grade_json
    FROM (
        SELECT
            grade_name,
            JSONB_OBJECT_AGG(status, cnt) AS cnt_map
        FROM grade_agg
        GROUP BY grade_name
    ) sub;

    -- 5. Return the complete JSON result
    RETURN JSONB_BUILD_OBJECT(
        'overall', overall_json,
        'by_day', by_day_json,
        'by_grade', by_grade_json
    );
END;
$$;




-- ===============================================
--  CLASSES STATISTICS [ADMIN ROLE]
-- ===============================================

CREATE OR REPLACE FUNCTION public.get_class_statistics_json(
    school_id_param BIGINT,
    class_id_param BIGINT,
    start_date TIMESTAMPTZ DEFAULT NULL,
    end_date TIMESTAMPTZ DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    result JSONB;
BEGIN

    WITH attendance_filtered AS (
        SELECT
            a.status,
            LOWER(TO_CHAR(a.attendance_date, 'Dy')) AS weekday
        FROM attendance a
        WHERE a.school_id = school_id_param
          AND a.class_id = class_id_param
          AND (
                start_date IS NULL
                OR end_date IS NULL
                OR a.attendance_date BETWEEN start_date AND end_date
          )
    ),

    attendance_stats AS (
        SELECT
            weekday,
            ROUND(
                100.0 * COUNT(*) FILTER (WHERE status = 'present')
                / NULLIF(COUNT(*), 0)
            )::INT AS present,

            ROUND(
                100.0 * COUNT(*) FILTER (WHERE status = 'absent')
                / NULLIF(COUNT(*), 0)
            )::INT AS absent,

            ROUND(
                100.0 * COUNT(*) FILTER (WHERE status = 'late')
                / NULLIF(COUNT(*), 0)
            )::INT AS late,

            ROUND(
                100.0 * COUNT(*) FILTER (WHERE status = 'excused')
                / NULLIF(COUNT(*), 0)
            )::INT AS excused
        FROM attendance_filtered
        GROUP BY weekday
    ),

    assignments_stats AS (
        SELECT
            s.name AS subject_name,
            u.name AS teacher_name,
            COUNT(a.id)::INT AS assignment_made_count
        FROM assignments a
        INNER JOIN subjects s
            ON s.id = a.subject_id
        INNER JOIN users u
            ON u.id = a.teacher_id
        WHERE a.school_id = school_id_param
          AND a.class_id = class_id_param
          AND (
                start_date IS NULL
                OR end_date IS NULL
                OR a.created_at BETWEEN start_date AND end_date
          )
        GROUP BY s.name, u.name
    ),

    quizzes_stats AS (
        SELECT
            s.name AS subject_name,
            u.name AS teacher_name,
            COUNT(q.id)::INT AS quizzes_made_count
        FROM quizzes q
        INNER JOIN subjects s
            ON s.id = q.subject_id
        INNER JOIN users u
            ON u.id = q.teacher_id
        WHERE q.school_id = school_id_param
          AND q.class_id = class_id_param
          AND (
                start_date IS NULL
                OR end_date IS NULL
                OR q.created_at BETWEEN start_date AND end_date
          )
        GROUP BY s.name, u.name
    ),

    assignment_submission_count AS (
        SELECT
            COUNT(ass.id)::INT AS total
        FROM assignment_student_submissions ass
        INNER JOIN assignments a
            ON a.id = ass.assignment_id
        WHERE a.school_id = school_id_param
          AND a.class_id = class_id_param
          AND (
                start_date IS NULL
                OR end_date IS NULL
                OR ass.created_at BETWEEN start_date AND end_date
          )
    ),

    quiz_submission_count AS (
        SELECT
            COUNT(qss.id)::INT AS total
        FROM quiz_student_submissions qss
        INNER JOIN quizzes q
            ON q.id = qss.quiz_id
        WHERE q.school_id = school_id_param
          AND q.class_id = class_id_param
          AND (
                start_date IS NULL
                OR end_date IS NULL
                OR qss.created_at BETWEEN start_date AND end_date
          )
    ),

    students_data AS (
        SELECT
            u.id AS student_id,
            u.name AS student_name,
            u.avatar_url
        FROM users u
        WHERE u.role = 'student'
          AND u.school_id = school_id_param
          AND EXISTS (
              SELECT 1
              FROM user_profiles up
              WHERE up.user_id = u.id
                AND up.class_id = class_id_param
          )
    )

    SELECT jsonb_build_object(

        -- Attendance By Day
        'attendance_by_day',
        jsonb_build_object(
            'mon', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='mon'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0)),

            'tue', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='tue'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0)),

            'wed', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='wed'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0)),

            'thu', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='thu'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0)),

            'fri', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='fri'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0)),

            'sat', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='sat'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0)),

            'sun', COALESCE((SELECT jsonb_build_object('present', COALESCE(present,0),'absent',COALESCE(absent,0),'late',COALESCE(late,0),'excused',COALESCE(excused,0)) FROM attendance_stats WHERE weekday='sun'),
                            jsonb_build_object('present',0,'absent',0,'late',0,'excused',0))
        ),

        -- Assignments By Subject
        'assignments_by_subject',
        COALESCE((
            SELECT jsonb_agg(
                jsonb_build_object(
                    'subject_name', subject_name,
                    'teacher_name', teacher_name,
                    'assignment_made_count', assignment_made_count
                )
            )
            FROM assignments_stats
        ), '[]'::JSONB),

        -- Quizzes By Subject
        'quizzes_by_subject',
        COALESCE((
            SELECT jsonb_agg(
                jsonb_build_object(
                    'subject_name', subject_name,
                    'teacher_name', teacher_name,
                    'quizzes_made_count', quizzes_made_count
                )
            )
            FROM quizzes_stats
        ), '[]'::JSONB),

        -- Assignment Submission Count
        'assignment_submissions_count',
        COALESCE((SELECT total FROM assignment_submission_count), 0),

        -- Quiz Submission Count
        'quiz_submissions_count',
        COALESCE((SELECT total FROM quiz_submission_count), 0),

        -- Students
        'students',
        COALESCE((
            SELECT jsonb_agg(
                jsonb_build_object(
                    'student_id', student_id,
                    'student_name', student_name,
                    'avatar_url', avatar_url
                )
            )
            FROM students_data
        ), '[]'::JSONB)

    )
    INTO result;

    RETURN result;
END;
$$;



-- ==============================================
-- HOME PAGE STATISTICS [ADMIN ROLE]
-- ==============================================

CREATE OR REPLACE FUNCTION public.get_school_overall_statistics_json(
    p_school_id BIGINT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'users',
        jsonb_build_object(
            'students',
            (
                SELECT jsonb_build_object(
                    'total', COUNT(*),
                    'active', COUNT(*) FILTER (WHERE status = 'active'),
                    'pending', COUNT(*) FILTER (WHERE status = 'pending'),
                    'suspended', COUNT(*) FILTER (WHERE status = 'suspended')
                )
                FROM users
                WHERE school_id = p_school_id
                  AND role = 'student'
            ),

            'parents',
            (
                SELECT jsonb_build_object(
                    'total', COUNT(*),
                    'active', COUNT(*) FILTER (WHERE status = 'active'),
                    'pending', COUNT(*) FILTER (WHERE status = 'pending'),
                    'suspended', COUNT(*) FILTER (WHERE status = 'suspended')
                )
                FROM users
                WHERE school_id = p_school_id
                  AND role = 'parent'
            ),

            'admins',
            (
                SELECT jsonb_build_object(
                    'total', COUNT(*),
                    'active', COUNT(*) FILTER (WHERE status = 'active'),
                    'pending', COUNT(*) FILTER (WHERE status = 'pending'),
                    'suspended', COUNT(*) FILTER (WHERE status = 'suspended')
                )
                FROM users
                WHERE school_id = p_school_id
                  AND role = 'admin'
            ),

            'teachers',
            (
                SELECT jsonb_build_object(
                    'total', COUNT(*),
                    'active', COUNT(*) FILTER (WHERE status = 'active'),
                    'pending', COUNT(*) FILTER (WHERE status = 'pending'),
                    'suspended', COUNT(*) FILTER (WHERE status = 'suspended'),

                    'teacher_count_by_subjects',
                    COALESCE(
                        (
                            SELECT jsonb_object_agg(subject_name, teacher_count)
                            FROM (
                                SELECT
                                    s.name AS subject_name,
                                    COUNT(*) AS teacher_count
                                FROM users u
                                JOIN user_profiles up
                                    ON up.user_id = u.id
                                JOIN subjects s
                                    ON s.id = up.subject_id
                                WHERE u.school_id = p_school_id
                                  AND u.role = 'teacher'
                                GROUP BY s.name
                            ) x
                        ),
                        '{}'::jsonb
                    )
                )
                FROM users
                WHERE school_id = p_school_id
                  AND role = 'teacher'
            )
        ),

        'school_statistics',
        jsonb_build_object(
            'quizzes_count',
            (
                SELECT COUNT(*)
                FROM quizzes
                WHERE school_id = p_school_id
            ),

            'assignments_count',
            (
                SELECT COUNT(*)
                FROM assignments
                WHERE school_id = p_school_id
            ),

            'library_resources_count',
            (
                SELECT COUNT(*)
                FROM library_resources
                WHERE school_id = p_school_id
            ),

            'competitions_count',
            (
                SELECT COUNT(*)
                FROM competitions
                WHERE school_id = p_school_id
            ),

            'classes_count',
            (
                SELECT COUNT(*)
                FROM classes
                WHERE school_id = p_school_id
            )
        )
    )
    INTO result;

    RETURN result;
END;
$$;





















-- ==============================================
-- GET CHANNELS [TEACHER ROLE]
-- ==============================================


CREATE OR REPLACE FUNCTION get_teacher_channels(
    p_school_id BIGINT,
    p_teacher_id UUID
)
RETURNS TABLE (
    id BIGINT,
    school_id BIGINT,
    grade JSONB,
    class JSONB
)
LANGUAGE sql
STABLE
AS $$
SELECT
    c.id,
    c.school_id,

    CASE
        WHEN g.id IS NULL THEN NULL
        ELSE jsonb_build_object(
            'id', g.id,
            'name', g.name
        )
    END AS grade,

    CASE
        WHEN cl.id IS NULL THEN NULL
        ELSE jsonb_build_object(
            'id', cl.id,
            'nickname', cl.nickname
        )
    END AS class

FROM channels c
LEFT JOIN grades g
    ON g.id = c.grade_id
LEFT JOIN classes cl
    ON cl.id = c.class_id
WHERE c.school_id = p_school_id
AND (
    c.grade_id IS NULL

    OR (
        c.class_id IS NULL
        AND EXISTS (
            SELECT 1
            FROM timetable t
            WHERE t.teacher_id = p_teacher_id
              AND t.school_id = c.school_id
              AND t.grade_id = c.grade_id
        )
    )

    OR EXISTS (
        SELECT 1
        FROM timetable t
        WHERE t.teacher_id = p_teacher_id
          AND t.school_id = c.school_id
          AND t.grade_id = c.grade_id
          AND t.class_id = c.class_id
    )
);
$$;



-- ============================================================================================
-- GET TEACHER'S ASSIGNED GRADES AND CLASSES FROM TIMETABLE TABLE [TEACHER ROLE]
-- ============================================================================================

CREATE OR REPLACE FUNCTION get_teacher_grade_classes(p_teacher_id uuid)
RETURNS TABLE (
    grade_id bigint,
    grade_name text,
    class_id bigint,
    class_name text
)
LANGUAGE sql
AS $$
SELECT DISTINCT ON (t.grade_id, t.class_id)
    t.grade_id,
    g.name,
    t.class_id,
    c.nickname
FROM timetable t
JOIN grades g ON g.id = t.grade_id
LEFT JOIN classes c ON c.id = t.class_id
WHERE t.teacher_id = p_teacher_id
ORDER BY
    t.grade_id,
    t.class_id NULLS FIRST,
    c.nickname;
$$;



-- ==============================================
-- GET CLASS STUDENTS ATTENDANCE [TEACHER ROLE]
-- ==============================================

CREATE OR REPLACE FUNCTION get_class_students_attendance(
    p_class_id BIGINT,
    p_date DATE
)
RETURNS TABLE(
    student_id UUID,
    student_name TEXT,
    avatar_url TEXT,
    attendance_id BIGINT,
    attendance_status TEXT,
    attendance_reason TEXT
)
LANGUAGE sql
AS $$
SELECT
    u.id,
    u.name,
    u.avatar_url,
    a.id,
    a.status,
    a.reason
FROM user_profiles up
JOIN users u
    ON u.id = up.user_id
LEFT JOIN attendance a
    ON a.student_id = u.id
    AND a.attendance_date = p_date
WHERE up.class_id = p_class_id
AND u.role = 'student'
ORDER BY u.name;
$$;






-- ==============================================================================
-- GET SUBJECTS THAT GRADE/CLASS TAKE BASED ON timetable TANLE [STUDENT ROLE]
-- ==============================================================================

CREATE OR REPLACE FUNCTION get_grade_class_subjects(
    p_grade_id BIGINT,
    p_class_id BIGINT
)
RETURNS TABLE (
    id BIGINT,
    name VARCHAR
)
LANGUAGE sql
STABLE
AS $$
    SELECT DISTINCT
        s.id,
        s.name
    FROM timetable t
    INNER JOIN subjects s
        ON s.id = t.subject_id
    WHERE t.grade_id = p_grade_id
      AND t.class_id = p_class_id
    ORDER BY s.name;
$$;









-- ==============================================================================
-- CHECK IF STUDENT SHOULD BE REWARDED WITH BADGE [STUDENT ROLE]
-- ==============================================================================

CREATE OR REPLACE FUNCTION check_reward_badges(
    p_user_id UUID
)
RETURNS TABLE (
    out_badge_id BIGINT,
    out_badge_name TEXT,
    out_badge_icon_url TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    badge RECORD;
    user_progress INT;
BEGIN

    FOR badge IN
        SELECT *
        FROM badges
    LOOP

        user_progress := 0;

        CASE badge.requirement

            WHEN 'assignment_count' THEN
                SELECT COUNT(*)
                INTO user_progress
                FROM assignment_student_submissions
                WHERE student_id = p_user_id;

            WHEN 'quiz_count' THEN
                SELECT COUNT(*)
                INTO user_progress
                FROM quiz_student_submissions
                WHERE student_id = p_user_id;

            WHEN 'competition_count' THEN
                SELECT COUNT(*)
                INTO user_progress
                FROM competition_student_submissions
                WHERE student_id = p_user_id;

            WHEN 'attendance_count' THEN
                SELECT COUNT(*)
                INTO user_progress
                FROM attendance
                WHERE student_id = p_user_id
                  AND status = 'present';

            WHEN 'message_count' THEN
                SELECT COUNT(*)
                INTO user_progress
                FROM channel_messages
                WHERE sender_id = p_user_id;

            WHEN 'points' THEN
                SELECT points
                INTO user_progress
                FROM user_progress
                WHERE user_id = p_user_id;

            WHEN 'current_streak' THEN
                SELECT current_streak
                INTO user_progress
                FROM user_progress
                WHERE user_id = p_user_id;

            WHEN 'longest_streak' THEN
                SELECT longest_streak
                INTO user_progress
                FROM user_progress
                WHERE user_id = p_user_id;

            ELSE
                user_progress := 0;

        END CASE;

        IF user_progress >= badge.requirement_value THEN

            INSERT INTO user_badges (
                user_id,
                badge_id
            )
            VALUES (
                p_user_id,
                badge.id
            )
            ON CONFLICT (user_id, badge_id) DO NOTHING;

            IF FOUND THEN
                out_badge_id := badge.id;
                out_badge_name := badge.name;
                out_badge_icon_url := badge.icon_url;
                RETURN NEXT;
            END IF;

        END IF;

    END LOOP;

END;
$$;