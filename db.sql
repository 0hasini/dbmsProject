drop database if exists lawrecords;
create database lawrecords;
use lawrecords;

create table users(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    Fname VARCHAR(30) NOT NULL,
    Lname VARCHAR(30) NOT NULL,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    country_code VARCHAR(5),
    phone_no VARCHAR(15),
    street_no VARCHAR(5),
    street_name VARCHAR(50),
    building_name VARCHAR(50),
    city VARCHAR(25),
    state VARCHAR(25),
    pincode VARCHAR(10),
    role ENUM('Lawyer', 'Client') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP  
);

create table lawyers(
	lawyer_id INT PRIMARY KEY,
    specialization VARCHAR(50) NOT NULL,
    license_number VARCHAR(30) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lawyer_id) REFERENCES users(user_id) ON DELETE CASCADE
);

create table clients(
	client_id INT PRIMARY KEY,
    identification_no VARCHAR(20),
    emergency_contact VARCHAR(15),
    total_cases_filed INT, -- can be calculated by searching 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES users(user_id) ON DELETE CASCADE
);

create table cases (
    case_id VARCHAR(10) PRIMARY KEY,
    client_id INT,
    lawyer_id INT,
    case_number VARCHAR(255) UNIQUE NOT NULL,
    case_type VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('Open', 'In Progress', 'Closed', 'On Hold') NOT NULL,
    court_name VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id) ON DELETE SET NULL
);

create table case_updates(
    entry_id VARCHAR(10) PRIMARY KEY,
    lawyer_id INT,
    case_id VARCHAR(10),
    update_date DATE NOT NULL,
    task_description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id) ON DELETE CASCADE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);

create table case_documents (
    document_id VARCHAR(10) PRIMARY KEY,
    case_id VARCHAR(10) NOT NULL,
    document_type ENUM('Legal Document', 'Evidence', 'Discovery', 'Witness Statement') NOT NULL,
    status ENUM('Draft', 'Final', 'Revoked') NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);

-- RELATIONSHIPS
create table files (
    client_id INT,
    case_id VARCHAR(10),
    PRIMARY KEY (client_id, case_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);

create table handles (
    lawyer_id INT,
    case_id VARCHAR(10),
    PRIMARY KEY (lawyer_id, case_id),
    FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id) ON DELETE CASCADE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);


-- USERS TABLE INSERTS (Mixture of lawyers and clients)
INSERT INTO users (user_id, Fname, Lname, username, password, email, country_code, phone_no, street_no, street_name, building_name, city, state, pincode, role) VALUES
(1001, 'Rajesh', 'Mehta', 'rajesh', 'pK7$dR9#mL2!', 'rajesh.mehta@gmail.com', '+91', '9876543210', '42', 'Park Avenue', 'Sunrise Apartments', 'Mumbai', 'Maharashtra', '400001', 'Lawyer'),
(1002, 'Priya', 'Sharma', 'priya', 'tG8@pL4&zX3%', 'priya.sharma@yahoo.com', '+91', '8765432109', '15', 'MG Road', 'Green View', 'Delhi', 'Delhi', '110001', 'Lawyer'),
(1003, 'Amit', 'Patel', 'amit', 'bN5!qS7*cF2$', 'amit.patel@gmail.com', '+91', '7654321098', '8', 'Marine Drive', 'Sea Pearl', 'Mumbai', 'Maharashtra', '400002', 'Lawyer'),
(1004, 'Neha', 'Singh', 'neha', 'hJ6@vM3#kP9!', 'neha.singh@yahoo.com', '+91', '6543210987', '23', 'Cunningham Road', 'Rose Villa', 'Bangalore', 'Karnataka', '560001', 'Lawyer'),
(1005, 'Vikram', 'Reddy', 'vikram', 'fD2#tR8&yU4!', 'vikram.reddy@gmail.com', '+91', '9876543211', '12', 'Jubilee Hills', 'Maplewood', 'Hyderabad', 'Telangana', '500033', 'Lawyer'),
(1006, 'Ananya', 'Joshi', 'ananya', 'mZ3$xC7!vB5&', 'ananya.joshi@gmail.com', '+91', '8765432108', '5', 'Civil Lines', 'Golden Heights', 'Ahmedabad', 'Gujarat', '380001', 'Lawyer'),
(1007, 'Suresh', 'Kumar', 'suresh', 'pL9*kM4$bN2!', 'suresh.kumar@yahoo.com', '+91', '7654321097', '35', 'Church Street', 'Silver Crest', 'Chennai', 'Tamil Nadu', '600001', 'Lawyer'),
(1008, 'Divya', 'Gupta', 'divya', 'tS8@zX5#cV3!', 'divya.gupta@gmail.com', '+91', '6543210986', '14', 'Koregaon Park', 'Orchid Heights', 'Pune', 'Maharashtra', '411001', 'Lawyer'),
(1009, 'Karthik', 'Nair', 'karthik', 'jK7$fD9#hG3!', 'karthik.nair@gmail.com', '+91', '9876543212', '27', 'Race Course Road', 'Palm Grove', 'Coimbatore', 'Tamil Nadu', '641001', 'Lawyer'),
(1010, 'Pooja', 'Malhotra', 'pooja', 'vC4*nB7&qZ2%', 'pooja.malhotra@yahoo.com', '+91', '8765432107', '9', 'Mall Road', 'Emerald View', 'Chandigarh', 'Punjab', '160001', 'Lawyer'),
(1011, 'Gopal', 'Verma', 'gopal', 'xS5!dF8*kL3$', 'gopal.verma@gmail.com', '+91', '7654321096', '16', 'Connaught Place', 'Ruby Residency', 'Delhi', 'Delhi', '110002', 'Lawyer'),
(1012, 'Shreya', 'Saxena', 'shreya', 'bH6@mN3#pR9!', 'shreya.saxena@gmail.com', '+91', '6543210985', '30', 'Infantry Road', 'Diamond Park', 'Bangalore', 'Karnataka', '560002', 'Lawyer'),
(1013, 'Arjun', 'Menon', 'arjun', 'gT2#yU8&fJ4!', 'arjun.menon@yahoo.com', '+91', '9876543213', '7', 'Banjara Hills', 'Sapphire Towers', 'Hyderabad', 'Telangana', '500034', 'Lawyer'),
(1014, 'Ritu', 'Choudhary', 'ritu', 'kZ3$cX7!vM5&', 'ritu.choudhary@gmail.com', '+91', '8765432106', '18', 'Law Garden', 'Ivy Mansion', 'Ahmedabad', 'Gujarat', '380002', 'Lawyer'),
(1015, 'Deepak', 'Iyer', 'deepak', 'pJ9*qM4$tN2!', 'deepak.iyer@gmail.com', '+91', '7654321095', '41', 'TTK Road', 'Pine Valley', 'Chennai', 'Tamil Nadu', '600002', 'Lawyer'),
(1016, 'Anita', 'Agarwal', 'anita', 'cR8@zF5#bV3!', 'anita.agarwal@gmail.com', '+44', '7700900123', '10', 'Berkeley Street', 'Hawthorn Lodge', 'London', 'England', 'W1J 8DL', 'Client'),
(1017, 'Sanjay', 'Khanna', 'sanjay', 'hG7$dS9#jK3!', 'sanjay.khanna@yahoo.com', '+91', '9876543214', '22', 'Linking Road', 'Cedar Court', 'Mumbai', 'Maharashtra', '400003', 'Client'),
(1018, 'Meera', 'Bajaj', 'meera', 'vB4*mZ7&xP2%', 'meera.bajaj@gmail.com', '+91', '8765432105', '6', 'Parliament Street', 'Willow Heights', 'Delhi', 'Delhi', '110003', 'Client'),
(1019, 'Rahul', 'Chopra', 'rahul', 'nF5!qS8*bL3$', 'rahul.chopra@yahoo.com', '+1', '2125556789', '345', 'Park Avenue', 'The Regency', 'New York', 'NY', '10022', 'Client'),
(1020, 'Kavita', 'Desai', 'kavita', 'tJ6@pR3#mV9!', 'kavita.desai@gmail.com', '+91', '6543210984', '29', 'Brigade Road', 'Maple Residency', 'Bangalore', 'Karnataka', '560003', 'Client'),
(1021, 'Rohit', 'Kapoor', 'rohit', 'fH2#yT8&gW4!', 'rohit.kapoor@gmail.com', '+91', '9876543215', '13', 'Film Nagar', 'Oak Mansion', 'Hyderabad', 'Telangana', '500035', 'Client'),
(1022, 'Shikha', 'Oberoi', 'shikha', 'kC3$vX7!bN5&', 'shikha.oberoi@yahoo.com', '+971', '501234567', '24', 'Sheikh Zayed Road', 'Palm Residences', 'Dubai', 'Dubai', '12345', 'Client'),
(1023, 'Vivek', 'Mathur', 'vivek', 'pL9*qK4$tM2!', 'vivek.mathur@gmail.com', '+91', '7654321094', '33', 'Relief Road', 'Cypress Gardens', 'Ahmedabad', 'Gujarat', '380003', 'Client'),
(1024, 'Nandini', 'Bose', 'nandini', 'wR8@zG5#cB3!', 'nandini.bose@gmail.com', '+91', '6543210983', '11', 'Pantheon Road', 'Birch Valley', 'Chennai', 'Tamil Nadu', '600003', 'Client'),
(1025, 'Alok', 'Mishra', 'alok', 'jH7$fS9#kL3!', 'alok.mishra@yahoo.com', '+91', '9876543216', '19', 'North Main Road', 'Magnolia Court', 'Pune', 'Maharashtra', '411002', 'Client'),
(1026, 'Tanya', 'Banerjee', 'tanya', 'vZ4*nC7&qP2%', 'tanya.banerjee@gmail.com', '+91', '8765432104', '36', 'Sector 17', 'Aspen Heights', 'Chandigarh', 'Punjab', '160002', 'Client'),
(1027, 'Gaurav', 'Tiwari', 'gaurav', 'dF5!sD8*bK3$', 'gaurav.tiwari@yahoo.com', '+91', '7654321093', '25', 'Rajpath', 'Sycamore Towers', 'Delhi', 'Delhi', '110004', 'Client'),
(1028, 'Preeti', 'Shah', 'preeti', 'tH6@mR3#pL9!', 'preeti.shah@gmail.com', '+91', '6543210982', '28', 'Residency Road', 'Juniper Lodge', 'Bangalore', 'Karnataka', '560004', 'Client'),
(1029, 'Nikhil', 'Rao', 'nikhil', 'gW2#yV8&fT4!', 'nikhil.rao@gmail.com', '+91', '9876543217', '4', 'Madhapur', 'Chestnut Place', 'Hyderabad', 'Telangana', '500036', 'Client'),
(1030, 'Roshni', 'Mehra', 'roshni', 'kB3$vZ7!bM5&', 'roshni.mehra@yahoo.com', '+91', '8765432103', '21', 'Satellite Road', 'Redwood Complex', 'Ahmedabad', 'Gujarat', '380004', 'Client');

-- LAWYERS TABLE INSERTS
INSERT INTO lawyers (lawyer_id, specialization, license_number, created_at) VALUES
(1001, 'Criminal Law', 'BCI12345678', '2022-01-15 09:30:00'),
(1002, 'Corporate Law', 'BCI23456789', '2022-02-20 10:15:00'),
(1003, 'Intellectual Property', 'BCI34567890', '2022-01-25 11:45:00'),
(1004, 'Family Law', 'BCI45678901', '2022-03-10 14:20:00'),
(1005, 'Real Estate Law', 'BCI56789012', '2022-02-05 16:30:00'),
(1006, 'Immigration Law', 'BCI67890123', '2022-03-22 09:10:00'),
(1007, 'Tax Law', 'BCI78901234', '2022-01-30 13:45:00'),
(1008, 'Labor Law', 'BCI89012345', '2022-02-12 15:20:00'),
(1009, 'Environmental Law', 'BCI90123456', '2022-03-05 10:30:00'),
(1010, 'Medical Law', 'BCI01234567', '2022-01-18 11:15:00'),
(1011, 'Constitutional Law', 'BCI12345679', '2022-02-27 14:50:00'),
(1012, 'Cyber Law', 'BCI23456780', '2022-03-15 16:10:00'),
(1013, 'Maritime Law', 'BCI34567891', '2022-01-22 09:25:00'),
(1014, 'Bankruptcy Law', 'BCI45678902', '2022-02-08 12:40:00'),
(1015, 'International Law', 'BCI56789013', '2022-03-19 15:55:00');

-- CLIENTS TABLE INSERTS
INSERT INTO clients (client_id, identification_no, emergency_contact, total_cases_filed, created_at) VALUES
(1016, 'AADHR123456789', '9898989898', 2, '2022-04-10 10:00:00'),
(1017, 'AADHR234567890', '8787878787', 1, '2022-04-15 11:30:00'),
(1018, 'AADHR345678901', '7676767676', 3, '2022-04-20 14:15:00'),
(1019, 'PASPT456789012', '5454545454', 1, '2022-04-25 16:45:00'),
(1020, 'AADHR567890123', '4343434343', 2, '2022-05-05 09:20:00'),
(1021, 'AADHR678901234', '3232323232', 1, '2022-05-10 13:40:00'),
(1022, 'PASPT789012345', '9191919191', 2, '2022-05-15 15:30:00'),
(1023, 'AADHR890123456', '8080808080', 3, '2022-05-20 10:45:00'),
(1024, 'AADHR901234567', '7070707070', 1, '2022-05-25 14:10:00'),
(1025, 'AADHR012345678', '6060606060', 2, '2022-06-01 11:25:00'),
(1026, 'AADHR123456780', '5050505050', 1, '2022-06-05 16:55:00'),
(1027, 'AADHR234567801', '4040404040', 3, '2022-06-10 09:35:00'),
(1028, 'AADHR345678012', '3030303030', 2, '2022-06-15 12:50:00'),
(1029, 'AADHR456780123', '2020202020', 1, '2022-06-20 15:15:00'),
(1030, 'AADHR567801234', '1010101010', 2, '2022-06-25 10:05:00');

-- CASES TABLE INSERTS
INSERT INTO cases (case_id, client_id, lawyer_id, case_number, case_type, title, description, status, court_name, created_at, updated_at) VALUES
('CA1001', 1016, 1001, 'CRR/2022/001234', 'Criminal', 'State vs. Agarwal', 'Alleged theft of intellectual property from former employer', 'In Progress', 'Delhi High Court', '2022-04-12 10:30:00', '2022-12-15 14:20:00'),
('CA1002', 1017, 1002, 'CIV/2022/002345', 'Civil', 'Khanna vs. Mumbai Properties Ltd', 'Breach of contract in property purchase agreement', 'Open', 'Mumbai Civil Court', '2022-04-18 11:45:00', '2022-11-20 09:15:00'),
('CA1003', 1018, 1003, 'IPR/2022/003456', 'Intellectual Property', 'Bajaj Enterprises vs. TechSoft Ltd', 'Patent infringement on proprietary software algorithm', 'In Progress', 'Delhi High Court', '2022-04-22 14:20:00', '2022-12-10 16:30:00'),
('CA1004', 1019, 1004, 'FAM/2022/004567', 'Family', 'Chopra vs. Chopra', 'International custody dispute', 'Open', 'New York Family Court', '2022-04-28 16:55:00', '2022-10-05 13:45:00'),
('CA1005', 1020, 1005, 'REA/2022/005678', 'Real Estate', 'Desai vs. Bangalore Development Authority', 'Dispute over land acquisition compensation', 'In Progress', 'Karnataka High Court', '2022-05-08 09:30:00', '2022-11-12 10:20:00'),
('CA1006', 1021, 1006, 'IMM/2022/006789', 'Immigration', 'In re: Kapoor Work Visa', 'Work visa extension application', 'Closed', 'Immigration Authority', '2022-05-12 13:50:00', '2022-09-25 15:40:00'),
('CA1007', 1022, 1007, 'TAX/2022/007890', 'Tax', 'Oberoi vs. Revenue Department', 'International tax dispute', 'In Progress', 'Tax Tribunal Dubai', '2022-05-18 15:35:00', '2022-12-20 11:25:00'),
('CA1008', 1023, 1008, 'LAB/2022/008901', 'Labor', 'Mathur vs. Gujarat Industries', 'Wrongful termination claim', 'On Hold', 'Gujarat Labor Court', '2022-05-23 10:50:00', '2022-11-30 14:15:00'),
('CA1009', 1024, 1009, 'ENV/2022/009012', 'Environmental', 'Bose vs. Chennai Chemical Corp', 'Environmental damage lawsuit', 'Open', 'National Green Tribunal', '2022-05-28 14:15:00', '2022-10-15 16:50:00'),
('CA1010', 1025, 1010, 'MED/2022/010123', 'Medical', 'Mishra vs. Pune General Hospital', 'Medical malpractice claim', 'In Progress', 'Maharashtra Medical Tribunal', '2022-06-03 11:30:00', '2022-12-05 09:40:00'),
('CA1011', 1026, 1011, 'CON/2022/011234', 'Constitutional', 'Banerjee vs. State of Punjab', 'Constitutional rights violation', 'Open', 'Punjab & Haryana High Court', '2022-06-08 17:05:00', '2022-11-10 13:30:00'),
('CA1012', 1027, 1012, 'CYB/2022/012345', 'Cyber Crime', 'Tiwari vs. Unknown Hackers', 'Online fraud and identity theft', 'In Progress', 'Delhi Cyber Crime Court', '2022-06-13 09:40:00', '2022-12-18 15:10:00'),
('CA1013', 1028, 1013, 'MAR/2022/013456', 'Maritime', 'Shah Shipping vs. Insurance Co.', 'Maritime insurance claim dispute', 'Closed', 'Maritime Arbitration Tribunal', '2022-06-18 12:55:00', '2022-09-30 10:35:00'),
('CA1014', 1029, 1014, 'BNK/2022/014567', 'Bankruptcy', 'In re: Rao Enterprises', 'Chapter 11 bankruptcy proceeding', 'On Hold', 'Bankruptcy Court Hyderabad', '2022-06-23 15:20:00', '2022-10-20 14:05:00'),
('CA1015', 1030, 1015, 'INT/2022/015678', 'International', 'Mehra vs. Global Corp Ltd', 'International business contract dispute', 'In Progress', 'International Commercial Arbitration', '2022-06-28 10:10:00', '2022-12-25 16:45:00');

-- CASE_DOCUMENTS TABLE INSERTS
-- CASE_DOCUMENTS TABLE INSERTS
INSERT INTO case_documents (document_id, case_id, document_type, status, description, file_path, created_at) VALUES
('CD1001', 'CA1001', 'Legal Document', 'Final', 'Criminal complaint filed by prosecution', 'https://drive.google.com/1016/CA1001/CD1001', '2022-04-12 11:30:00'),
('CD1002', 'CA1001', 'Evidence', 'Final', 'CCTV footage from company premises', 'https://drive.google.com/1016/CA1001/CD1002', '2022-04-13 10:15:00'),
('CD1003', 'CA1002', 'Legal Document', 'Final', 'Civil suit filing', 'https://drive.google.com/1017/CA1002/CD1003', '2022-04-18 12:45:00'),
('CD1004', 'CA1002', 'Evidence', 'Final', 'Property purchase agreement', 'https://drive.google.com/1017/CA1002/CD1004', '2022-04-19 14:20:00'),
('CD1005', 'CA1003', 'Legal Document', 'Final', 'Patent infringement complaint', 'https://drive.google.com/1018/CA1003/CD1005', '2022-04-22 15:20:00'),
('CD1006', 'CA1003', 'Evidence', 'Final', 'Patent documentation and proof of infringement', 'https://drive.google.com/1018/CA1003/CD1006', '2022-04-23 09:30:00'),
('CD1007', 'CA1004', 'Legal Document', 'Final', 'Custody petition', 'https://drive.google.com/1019/CA1004/CD1007', '2022-04-28 17:55:00'),
('CD1008', 'CA1004', 'Witness Statement', 'Final', 'Statement from family counselor', 'https://drive.google.com/1019/CA1004/CD1008', '2022-04-29 11:40:00'),
('CD1009', 'CA1005', 'Legal Document', 'Final', 'Land acquisition dispute filing', 'https://drive.google.com/1020/CA1005/CD1009', '2022-05-08 10:30:00'),
('CD1010', 'CA1005', 'Evidence', 'Final', 'Property valuation reports', 'https://drive.google.com/1020/CA1005/CD1010', '2022-05-09 14:15:00'),
('CD1011', 'CA1006', 'Legal Document', 'Final', 'Visa extension application', 'https://drive.google.com/1021/CA1006/CD1011', '2022-05-12 14:50:00'),
('CD1012', 'CA1006', 'Evidence', 'Final', 'Employment verification documents', 'https://drive.google.com/1021/CA1006/CD1012', '2022-05-13 16:25:00'),
('CD1013', 'CA1007', 'Legal Document', 'Final', 'Tax appeal filing', 'https://drive.google.com/1022/CA1007/CD1013', '2022-05-18 16:35:00'),
('CD1014', 'CA1007', 'Evidence', 'Final', 'Financial statements and tax records', 'https://drive.google.com/1022/CA1007/CD1014', '2022-05-19 10:20:00'),
('CD1015', 'CA1008', 'Legal Document', 'Final', 'Wrongful termination complaint', 'https://drive.google.com/1023/CA1008/CD1015', '2022-05-23 11:50:00');

-- CASE_UPDATES TABLE INSERTS
INSERT INTO case_updates (entry_id, lawyer_id, case_id, update_date, task_description, created_at) VALUES
('ED1001', 1001, 'CA1001', '2022-04-20', 'Initial client consultation completed. Reviewed all evidence provided by the client and prepared defense strategy outline for discussion in our next meeting.', '2022-04-20 14:30:00'),
('ED1002', 1001, 'CA1001', '2022-05-15', 'Filed motion to suppress key evidence based on procedural irregularities. Prepared client for upcoming preliminary hearing scheduled for next month.', '2022-05-15 16:45:00'),
('ED1003', 1002, 'CA1002', '2022-04-25', 'Conducted detailed review of property documents and contract terms. Identified multiple breaches that strengthen our position in negotiation.', '2022-04-25 11:20:00'),
('ED1004', 1002, 'CA1002', '2022-05-20', 'Sent formal notice to Mumbai Properties Ltd outlining contract breaches. Requested meeting with their legal representatives to discuss settlement terms.', '2022-05-20 10:40:00'),
('ED1005', 1003, 'CA1003', '2022-04-30', 'Completed comprehensive patent analysis with technical expert. Identified clear evidence of algorithm infringement that will support our claim in court.', '2022-04-30 13:15:00'),
('ED1006', 1003, 'CA1003', '2022-05-25', 'Received response from TechSoft denying infringement. Prepared detailed technical rebuttal with our patent expert for submission to the court next week.', '2022-05-25 15:50:00'),
('ED1007', 1004, 'CA1004', '2022-05-05', 'Filed jurisdictional challenge to contest case location. Gathered supporting documentation about child`s established residence and community connections.', '2022-05-05 09:10:00'),
('ED1008', 1004, 'CA1004', '2022-05-30', 'Attended mediation session with both parties. Outlined potential visitation schedule that may form the basis of settlement discussions.', '2022-05-30 14:25:00');

-- FILES TABLE INSERTS (Client-Case Relationship)
INSERT INTO files (client_id, case_id) VALUES
(1016, 'CA1001'),
(1017, 'CA1002'),
(1018, 'CA1003'),
(1019, 'CA1004'),
(1020, 'CA1005'),
(1023, 'CA1008'),
(1024, 'CA1009'),
(1025, 'CA1010'),
(1026, 'CA1011'),
(1027, 'CA1012'),
(1028, 'CA1013'),
(1029, 'CA1014'),
(1030, 'CA1015');

-- HANDLES TABLE INSERTS (Lawyer-Case Relationship)
INSERT INTO handles (lawyer_id, case_id) VALUES
(1001, 'CA1001'),
(1002, 'CA1002'),
(1003, 'CA1003'),
(1004, 'CA1004'),
(1005, 'CA1005'),
(1015, 'CA1015'),
(1001, 'CA1016'),
(1002, 'CA1017'),
(1003, 'CA1018'),
(1004, 'CA1019'),
(1005, 'CA1020');