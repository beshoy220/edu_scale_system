-- WELCOME TO EDU-SCALE DATABASE SCHEMA
-- THIS SCHEMA IS FOR 1.0.2 VERSION


-- =================== SCHOOLS ===================
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;

-- Policy for SELECT: only admin can read
CREATE POLICY "Admin can read schools" ON schools
    FOR SELECT USING (
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );

-- Policy for UPDATE: only admin can update
CREATE POLICY "Admin can update schools" ON schools
    FOR UPDATE USING (
        (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
    );






-- ==================== GRADES ====================
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any grade
CREATE POLICY "Authenticated users can read grades"
ON grades FOR SELECT TO authenticated USING (true);

-- Admin can INSERT grades
CREATE POLICY "Admin can insert grades" ON grades
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- ==================== CLASSES ====================
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any class
CREATE POLICY "Authenticated users can read classes"
ON classes FOR SELECT TO authenticated USING (true);

-- Admin can insert classes
CREATE POLICY "Admin can insert classes" ON classes
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- ==================== SUBJECTS ====================
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any subject
CREATE POLICY "Authenticated users can read subjects"
ON subjects FOR SELECT TO authenticated USING (true);

-- Admin can insert subjects
CREATE POLICY "Admin can insert subjects" ON subjects
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );








-- ==================== USERS ====================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Admin can select any user
CREATE POLICY "Admin can select users" ON users
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Teacher can select any user
CREATE POLICY "Teacher can select users" ON users
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher' );

-- Parent can select any user
CREATE POLICY "Parent can select users" ON users
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'parent' );

-- Student can select any user
CREATE POLICY "Student can select users" ON users
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'student' );

-- Admin can insert new users
CREATE POLICY "Admin can insert users" ON users
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Users can update their own row
CREATE POLICY "Users can update their own row" ON public.users
FOR UPDATE
USING (
    auth.uid() = id
)
WITH CHECK (
    auth.uid() = id
);

-- ==================== USER_PROFILES ====================
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Admin can select any user_profile
CREATE POLICY "Admin can select user_profiles" ON user_profiles
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Admin can insert user_profiles
CREATE POLICY "Admin can insert user_profiles" ON user_profiles
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Teacher can select any user_profiles
CREATE POLICY "Teacher can select user_profiles" ON user_profiles
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher' );

-- Parent can select any user_profiles
CREATE POLICY "Parent can select user_profiles" ON user_profiles
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'parent' );

-- Student can select any user_profiles
CREATE POLICY "Student can select user_profiles" ON user_profiles
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'student' );






-- ==================== ASSIGNMENTS ====================
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;

-- Auth users can select assignments
CREATE POLICY "Authenticated users can select assignments"
ON assignments FOR SELECT TO authenticated USING (true);

-- Teachers can insert on assignments
CREATE POLICY "Teachers can insert assignments"
ON assignments FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- Teachers can update on assignments
CREATE POLICY "Teachers can update assignments"
ON assignments FOR UPDATE TO authenticated USING (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
) WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- ==================== ASSIGNMENT_QUESTIONS ====================
ALTER TABLE assignment_questions ENABLE ROW LEVEL SECURITY;

-- Auth users can select assignment_questions
CREATE POLICY "Authenticated users can select assignment_questions"
ON assignment_questions FOR SELECT TO authenticated USING (true);

-- Teachers can insert on assignment_questions
CREATE POLICY "Teachers can insert assignment_questions"
ON assignment_questions FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- Teachers can update on assignment_questions
CREATE POLICY "Teachers can update assignment_questions"
ON assignment_questions FOR UPDATE TO authenticated USING (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
) WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- ==================== ASSIGNMENT_STUDENT_SUBMISSIONS ====================
ALTER TABLE assignment_student_submissions ENABLE ROW LEVEL SECURITY;

-- Auth users can select assignment_student_submissions
CREATE POLICY "Authenticated users can select assignment_student_submissions"
ON assignment_student_submissions FOR SELECT TO authenticated USING (true);

-- Student can insert on assignment_student_submissions
CREATE POLICY "Student can insert assignment_student_submissions"
ON assignment_student_submissions FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'student'
);

-- ==================== ASSIGNMENT_STUDENT_ANSWERS ====================
ALTER TABLE assignment_student_answers ENABLE ROW LEVEL SECURITY;

-- Admins can select assignment_student_answers
CREATE POLICY "Admin can select assignment_student_answers" ON assignment_student_answers
FOR SELECT USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Student can insert on assignment_student_answers
CREATE POLICY "Student can insert assignment_student_answers"
ON assignment_student_answers FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'student'
);





-- ==================== QUIZZES ====================
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;

-- Auth users can select quizzes
CREATE POLICY "Authenticated users can select quizzes"
ON quizzes FOR SELECT TO authenticated USING (true);

-- Teachers can insert on quizzes
CREATE POLICY "Teachers can insert quizzes"
ON quizzes FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- Teachers can update on quizzes
CREATE POLICY "Teachers can update quizzes"
ON quizzes FOR UPDATE TO authenticated USING (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
) WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);


-- ==================== QUIZ_QUESTIONS ====================
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;

-- Auth users can select quiz_questions
CREATE POLICY "Authenticated users can select quiz_questions"
ON quiz_questions FOR SELECT TO authenticated USING (true);

-- Teachers can insert on quiz_questions
CREATE POLICY "Teachers can insert quiz_questions"
ON quiz_questions FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- Teachers can update on quiz_questions
CREATE POLICY "Teachers can update quiz_questions"
ON quiz_questions FOR UPDATE TO authenticated USING (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
) WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- ==================== QUIZ_STUDENT_SUBMISSIONS ====================
ALTER TABLE quiz_student_submissions ENABLE ROW LEVEL SECURITY;

-- Auth users can select quiz_student_submissions
CREATE POLICY "Authenticated users can select quiz_student_submissions"
ON quiz_student_submissions FOR SELECT TO authenticated USING (true);

-- Student can insert on quiz_student_submissions
CREATE POLICY "Student can insert quiz_student_submissions"
ON quiz_student_submissions FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'student'
);

-- ==================== QUIZ_STUDENT_ANSWERS ====================
ALTER TABLE quiz_student_answers ENABLE ROW LEVEL SECURITY;

-- Admins can select quiz_student_answers
CREATE POLICY "Admin can select quiz_student_answers" ON quiz_student_answers
    FOR SELECT
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Student can insert on quiz_student_answers
CREATE POLICY "Student can insert quiz_student_answers"
ON quiz_student_answers FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'student'
);






-- ==================== LIBRARY_RESOURCES ====================
ALTER TABLE library_resources ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any library resource
CREATE POLICY "Authenticated users can select library_resources"
ON library_resources FOR SELECT TO authenticated USING (true);

-- Teacher can insert on library_resources
CREATE POLICY "Teacher can insert library_resources" ON library_resources
FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- Admin can update any library resource
CREATE POLICY "Admin can update library_resources" ON library_resources
    FOR UPDATE
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );






-- ==================== CHANNELS ====================
ALTER TABLE channels ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any channels
CREATE POLICY "Authenticated users can select channels"
ON channels FOR SELECT TO authenticated USING (true);

-- Admin can insert new channels
CREATE POLICY "Admin can insert channels" ON channels
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- ==================== CHANNEL_MESSAGES ====================
ALTER TABLE channel_messages ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any channels
CREATE POLICY "Authenticated users can select channel_messages"
ON channel_messages FOR SELECT TO authenticated USING (true);

-- Admin can insert new channel messages
CREATE POLICY "Admin can insert channel_messages" ON channel_messages
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );






-- ==================== COMPETITION ====================
--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------






-- ==================== TIMETABLE ====================
ALTER TABLE timetable ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any timetable
CREATE POLICY "Authenticated users can select timetable"
ON timetable FOR SELECT TO authenticated USING (true);

-- Admin can insert new timetable entries
CREATE POLICY "Admin can insert timetable" ON timetable
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Admin can delete timetable
CREATE POLICY "Admin can delete timetable" ON timetable
    FOR DELETE
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- ==================== EVENTS ====================
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Authenticated user can select any event
CREATE POLICY "Authenticated user can select events"
ON events FOR SELECT TO authenticated USING (true);

-- Admin can insert new events
CREATE POLICY "Admin can insert events" ON events
    FOR INSERT
    WITH CHECK ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );

-- Admin can delete event
CREATE POLICY "Admin can delete events" ON events
    FOR DELETE
    USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );





-- ==================== ATTENDANCE ====================
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Authenticated user can select any attendance
CREATE POLICY "Authenticated user can select attendance"
ON attendance FOR SELECT TO authenticated USING (true);

-- Teachers can insert on attendance
CREATE POLICY "Teachers can insert attendance"
ON attendance FOR INSERT TO authenticated WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);

-- Teachers can update on attendance
CREATE POLICY "Teachers can update attendance"
ON attendance FOR UPDATE TO authenticated USING (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
) WITH CHECK (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'teacher'
);





-- ==================== USER_NOTIFICATIONs ====================
ALTER TABLE user_notifications ENABLE ROW LEVEL SECURITY;

-- Authenticated can select any notification
CREATE POLICY "Authenticated users can read notifications"
ON user_notifications FOR SELECT TO authenticated USING (true);






-- ==================== USER_PROGRESS ====================
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Authenticated users can view all user progress
CREATE POLICY "Authenticated users can select user progress"
ON user_progress FOR SELECT TO authenticated USING (true);

-- Users can update only their own progress
CREATE POLICY "Users can update own progress"
ON user_progress FOR UPDATE TO authenticated USING (
    auth.uid() = user_id
)
WITH CHECK (
    auth.uid() = user_id
);

-- ==================== BADGES ====================
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;

-- Authenticated users can view all badges
CREATE POLICY "Authenticated users can select badges"
ON badges FOR SELECT TO authenticated USING (true);

-- ==================== USER_BADGES ====================
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

-- Authenticated users can view all earned badges
CREATE POLICY "Authenticated users can select user badges"
ON user_badges FOR SELECT TO authenticated USING (true);

















-- ==================== STORAGE POLICES ("library" bucket) ================================
CREATE POLICY "Authenticated users can upload"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'library'
);

CREATE POLICY "Authenticated users can read"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'library'
);
