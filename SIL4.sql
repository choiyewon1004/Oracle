--14--
SELECT A.STUDENT_NAME AS "학생이름",
        DECODE(A.COACH_PROFESSOR_NO,NULL,'지도교수 미지정', C.PROFESSOR_NAME) AS "지도교수"
FROM TB_STUDENT A
    LEFT JOIN TB_PROFESSOR C ON A.COACH_PROFESSOR_NO = C.PROFESSOR_NO
WHERE A.DEPARTMENT_NO = (
                        SELECT DEPARTMENT_NO
                        FROM TB_DEPARTMENT
                        WHERE DEPARTMENT_NAME = '서반아어학과')
ORDER BY STUDENT_NO;

--15--
SELECT A.STUDENT_NO "학번",
        A.STUDENT_NAME "이름",
        (
            SELECT DEPARTMENT_NAME
            FROM TB_DEPARTMENT C
            WHERE A.DEPARTMENT_NO = C.DEPARTMENT_NO
        ) AS "학과이름",
        ROUND((
            SELECT AVG(POINT)
            FROM TB_GRADE B
            WHERE A.STUDENT_NO = B.STUDENT_NO
            GROUP BY B.STUDENT_NO
        ),4)   AS "평점"
FROM TB_STUDENT A
WHERE ABSENCE_YN ='N' 
    AND
    (
        SELECT AVG(POINT)
        FROM TB_GRADE B
        WHERE A.STUDENT_NO = B.STUDENT_NO
        GROUP BY B.STUDENT_NO
    )>= 4.0
ORDER BY A.STUDENT_NO;


--16--
SELECT A.CLASS_NO, A.CLASS_NAME,
        ROUND((
            SELECT AVG(SUBA.POINT)
            FROM TB_GRADE SUBA
            WHERE SUBA.CLASS_NO = A.CLASS_NO
            GROUP BY SUBA.CLASS_NO
        ),8) "AVG(POINT)"
FROM TB_CLASS A
WHERE DEPARTMENT_NO = (
                        SELECT DEPARTMENT_NO
                        FROM TB_DEPARTMENT 
                        WHERE DEPARTMENT_NAME='환경조경학과' 
                        )
    AND CLASS_TYPE IN ('전공필수', '전공선택')
ORDER BY A.CLASS_NO;

--17--
SELECT STUDENT_NAME , STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (
                        SELECT DEPARTMENT_NO
                        FROM TB_STUDENT 
                        WHERE STUDENT_NAME='최경희' 
                        );
                        
--18--

SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO = (SELECT STUDENT_NO
                    FROM (
                            SELECT A.STUDENT_NO 
                            FROM TB_STUDENT A
                                JOIN TB_GRADE B ON A.STUDENT_NO = B.STUDENT_NO
                            WHERE DEPARTMENT_NO = (
                                                    SELECT DEPARTMENT_NO
                                                    FROM TB_DEPARTMENT 
                                                    WHERE DEPARTMENT_NAME='국어국문학과' 
                                                    )
                            GROUP BY A.STUDENT_NO
                            ORDER BY AVG(B.POINT) DESC
                            )
                    WHERE ROWNUM=1
                    );
                    
--19--
SELECT B.DEPARTMENT_NO, 
        (
            SELECT SUBT.DEPARTMENT_NAME
            FROM TB_DEPARTMENT SUBT
            WHERE SUBT.DEPARTMENT_NO=B.DEPARTMENT_NO
        ) "계열 학과명",
        ROUND(AVG(POINT),1) AS "전공평점"
FROM TB_GRADE  A
    JOIN TB_CLASS B ON A.CLASS_NO = B.CLASS_NO
WHERE DEPARTMENT_NO IN (
                        SELECT SUBA.DEPARTMENT_NO
                        FROM TB_DEPARTMENT SUBA
                        WHERE SUBA.CATEGORY = (
                                                SELECT CATEGORY
                                                FROM TB_DEPARTMENT 
                                                WHERE DEPARTMENT_NAME = '환경조경학과'
                                                )
                        )
        AND CLASS_TYPE IN ('전공필수','전공선택')
GROUP BY DEPARTMENT_NO;

                