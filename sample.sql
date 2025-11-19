
-- blood groups
INSERT OR IGNORE INTO blood_group(group_name, rhesus) VALUES
('A+','+'),('A-','-'),('B+','+'),('B-','-'),('O+','+'),('O-','-'),('AB+','+'),('AB-','-');

-- organs
INSERT OR IGNORE INTO organ(organ_name, description) VALUES
('Kidney','Kidney'),('Liver','Liver'),('Heart','Heart'),('Lung','Lung');

-- hospitals
INSERT OR IGNORE INTO hospital(name,address,city,phone,primary_color,secondary_color) VALUES
('AIIMS Delhi','Ansari Nagar, New Delhi','Delhi','011-2658xxxx','#d6336c','#0d6efd'),
('Fortis Hospital','Okhla Road, New Delhi','Delhi','011-6698xxxx','#0d6efd','#198754'),
('Max Healthcare','Gurgaon','Gurgaon','0124-xxxx','#6f42c1','#fd7e14');

-- donors (15+)
INSERT OR IGNORE INTO donor(name,age,gender,phone,email,bg_id,organs_available,last_donation,hospital_id,registered_at) VALUES
('Donor One',28,'Male','9000000001','d1@example.com',1,'Kidney, Liver','2024-01-10',1, '2025-10-01 10:00:00'),
('Donor Two',30,'Female','9000000002','d2@example.com',2,'None','2025-01-05',1, '2025-10-02 11:00:00'),
('Donor Three',35,'Male','9000000003','d3@example.com',3,'Kidney','2024-05-10',2, '2025-10-03 12:00:00'),
('Donor Four',40,'Female','9000000004','d4@example.com',4,'Liver','2023-12-12',2, '2025-10-04 13:00:00'),
('Donor Five',22,'Male','9000000005','d5@example.com',5,'None',NULL,3, '2025-10-05 14:00:00'),
('Donor Six',45,'Male','9000000006','d6@example.com',6,'Kidney','2024-07-01',1, '2025-10-06 15:00:00'),
('Donor Seven',50,'Female','9000000007','d7@example.com',7,'Heart','2022-03-03',2, '2025-10-07 16:00:00'),
('Donor Eight',29,'Male','9000000008','d8@example.com',8,'Lung','2023-08-08',3, '2025-10-08 17:00:00'),
('Donor Nine',33,'Female','9000000009','d9@example.com',1,'Kidney','2024-09-09',1, '2025-10-09 09:00:00'),
('Donor Ten',26,'Male','9000000010','d10@example.com',5,'None',NULL,2, '2025-10-10 09:30:00'),
('Donor Eleven',31,'Female','9000000011','d11@example.com',3,'Liver','2025-02-02',3, '2025-10-11 10:30:00'),
('Donor Twelve',38,'Male','9000000012','d12@example.com',2,'Kidney','2024-11-11',1, '2025-10-12 11:30:00'),
('Donor Thirteen',27,'Male','9000000013','d13@example.com',4,'Kidney','2025-03-03',2, '2025-10-13 12:30:00'),
('Donor Fourteen',36,'Female','9000000014','d14@example.com',6,'None',NULL,3, '2025-10-14 13:30:00'),
('Donor Fifteen',41,'Male','9000000015','d15@example.com',1,'Liver','2024-06-06',1, '2025-10-15 14:30:00'),
('Donor Sixteen',47,'Female','9000000016','d16@example.com',5,'Kidney','2025-01-01',2, '2025-10-16 15:30:00');

-- patients
INSERT OR IGNORE INTO patient(name,age,gender,phone,email,required_bg,organ_needed,hospital_id) VALUES
('Amit Kumar',45,'Male','9965543322','amit@example.com','A+','Kidney',1),
('Neha Singh',29,'Female','9955443322','neha@example.com','O+','Liver',2);

-- blood inventory
INSERT OR IGNORE INTO blood_inventory(hospital_id,bg_id,units) VALUES
(1,1,10),(1,5,4),(2,1,8),(2,5,6),(3,3,5);

-- organ inventory
INSERT OR IGNORE INTO organ_inventory(hospital_id,organ_name,availability) VALUES
(1,'Kidney',2),(1,'Liver',1),(2,'Kidney',0),(2,'Liver',1),(3,'Kidney',1);

-- admin
INSERT OR IGNORE INTO admin(username,password) VALUES ('admin','password');
