-- Аналитические запросы: демонстрация JOIN, GROUP BY, оконных функций, CTE

-- 1. Проекты и задачи по каждому клиенту
SELECT c.company_name,
       COUNT(DISTINCT p.id) AS projects_count,
       COUNT(t.id) AS tasks_count
FROM clients c
JOIN projects p ON p.client_id = c.id
LEFT JOIN tasks t ON t.project_id = p.id
GROUP BY c.company_name
ORDER BY projects_count DESC;

-- 2. Загрузка сотрудников: активные и завершённые задачи
SELECT e.full_name,
       COUNT(t.id) FILTER (WHERE t.status = 'in_progress') AS active_tasks,
       COUNT(t.id) FILTER (WHERE t.status = 'done') AS done_tasks
FROM employees e
LEFT JOIN tasks t ON t.assignee_id = e.id
GROUP BY e.full_name
ORDER BY active_tasks DESC;

-- 3. Просроченные задачи с контекстом проекта и клиента
SELECT t.title, p.name AS project, c.company_name AS client, t.due_date
FROM tasks t
JOIN projects p ON p.id = t.project_id
JOIN clients c ON c.id = p.client_id
WHERE t.due_date < CURRENT_DATE AND t.status != 'done';

-- 4. Ранжирование клиентов по количеству проектов (оконная функция)
SELECT company_name,
       COUNT(p.id) AS projects_count,
       RANK() OVER (ORDER BY COUNT(p.id) DESC) AS rank
FROM clients c
JOIN projects p ON p.client_id = c.id
GROUP BY company_name;

-- 5. Средний срок выполнения задачи по сотрудникам (CTE)
WITH task_duration AS (
    SELECT assignee_id,
           due_date - created_at::date AS duration_days
    FROM tasks
    WHERE status = 'done'
)
SELECT e.full_name, ROUND(AVG(td.duration_days), 1) AS avg_days
FROM task_duration td
JOIN employees e ON e.id = td.assignee_id
GROUP BY e.full_name;

-- 6. Клиенты без активных проектов (подзапрос NOT EXISTS)
SELECT c.company_name
FROM clients c
WHERE NOT EXISTS (
    SELECT 1 FROM projects p
    WHERE p.client_id = c.id AND p.status = 'in_progress'
);
