--14--
SELECT A.STUDENT_NAME AS "�л��̸�",
        DECODE(A.COACH_PROFESSOR_NO,NULL,'�������� ������', C.PROFESSOR_NAME) AS "��������"
FROM TB_STUDENT A
    LEFT JOIN TB_PROFESSOR C ON A.COACH_PROFESSOR_NO = C.PROFESSOR_NO
WHERE A.DEPARTMENT_NO = (
                        SELECT DEPARTMENT_NO
                        FROM TB_DEPARTMENT
                        WHERE DEPARTMENT_NAME = '���ݾƾ��а�')
ORDER BY STUDENT_NO;

--15--
SELECT A.STUDENT_NO "�й�",
        A.STUDENT_NAME "�̸�",
        (
            SELECT DEPARTMENT_NAME
            FROM TB_DEPARTMENT C
            WHERE A.DEPARTMENT_NO = C.DEPARTMENT_NO
        ) AS "�а��̸�",
        ROUND((
            SELECT AVG(POINT)
            FROM TB_GRADE B
            WHERE A.STUDENT_NO = B.STUDENT_NO
            GROUP BY B.STUDENT_NO
        ),4)   AS "����"
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
                        WHERE DEPARTMENT_NAME='ȯ�������а�' 
                        )
    AND CLASS_TYPE IN ('�����ʼ�', '��������')
ORDER BY A.CLASS_NO;

--17--
SELECT STUDENT_NAME , STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (
                        SELECT DEPARTMENT_NO
                        FROM TB_STUDENT 
                        WHERE STUDENT_NAME='�ְ���' 
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
                                                    WHERE DEPARTMENT_NAME='������а�' 
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
        ) "�迭 �а���",
        ROUND(AVG(POINT),1) AS "��������"
FROM TB_GRADE  A
    JOIN TB_CLASS B ON A.CLASS_NO = B.CLASS_NO
WHERE DEPARTMENT_NO IN (
                        SELECT SUBA.DEPARTMENT_NO
                        FROM TB_DEPARTMENT SUBA
                        WHERE SUBA.CATEGORY = (
                                                SELECT CATEGORY
                                                FROM TB_DEPARTMENT 
                                                WHERE DEPARTMENT_NAME = 'ȯ�������а�'
                                                )
                        )
        AND CLASS_TYPE IN ('�����ʼ�','��������')
GROUP BY DEPARTMENT_NO;

                