CREATE DATABASE NovaStoreDB;
GO



USE NovaStoreDB;
GO


-- BOLUM 1: Kategoriler tablosu
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);



GO

-- BOLUM 1: Musteriler tablosu
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);



GO

-- BOLUM 1: Urunler tablosu
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);



GO

-- BOLUM 1: Siparisler tablosu
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);



GO

-- BOLUM 1: Siparis detaylari tablosu
CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


GO

-- BOLUM 2: Kategori verilerini ekleme
INSERT INTO Categories (CategoryName)
VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yasam');

-- Eklenen kategorileri listeleme
SELECT * FROM Categories;




GO

-- BOLUM 2: Urun verilerini ekleme
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES
('Laptop', 28500.00, 15, 1),
('Mouse', 450.00, 50, 1),
('Kulaklik', 1250.00, 12, 1),

('Tisort', 350.00, 40, 2),
('Kot Pantolon', 1200.00, 18, 2),
('Spor Ayakkabi', 1800.00, 25, 2),

('SQL Kitabi', 550.00, 10, 3),
('Roman', 250.00, 35, 3),

('Sampuan', 180.00, 60, 4),
('Parfum', 1500.00, 8, 4),

('Kahve Makinesi', 3200.00, 14, 5),
('Masa Lambasi', 750.00, 30, 5);

-- Eklenen urunleri listeleme
SELECT * FROM Products;





GO

-- BOLUM 2: Musteri verilerini ekleme
INSERT INTO Customers (FullName, City, Email)
VALUES
('Ahmet Yilmaz', 'Istanbul', 'ahmet.yilmaz@example.com'),
('Ayse Demir', 'Ankara', 'ayse.demir@example.com'),
('Mehmet Kaya', 'Izmir', 'mehmet.kaya@example.com'),
('Zeynep Celik', 'Bursa', 'zeynep.celik@example.com'),
('Ali Sahin', 'Antalya', 'ali.sahin@example.com'),
('Elif Arslan', 'Konya', 'elif.arslan@example.com');

-- Eklenen musterileri listeleme
SELECT * FROM Customers;





GO

-- BOLUM 2: Siparis verilerini ekleme
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '20261010', 28950.00),
(2, '20261012', 1900.00),
(3, '20261015', 1050.00),
(4, '20261018', 1860.00),
(5, '20261021', 3950.00),
(6, '20261024', 2150.00),
(1, '20261028', 2150.00),
(2, '20261101', 3000.00),
(3, '20261105', 29750.00),
(4, '20261109', 1750.00);

-- Eklenen siparisleri listeleme
SELECT * FROM Orders;



GO

-- BOLUM 2: Siparis detaylarini ekleme
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
-- Siparis 1: 28950 TL
(1, 1, 1),
(1, 2, 1),

-- Siparis 2: 1900 TL
(2, 5, 1),
(2, 2, 1),
(2, 8, 1),

-- Siparis 3: 1050 TL
(3, 7, 1),
(3, 8, 2),

-- Siparis 4: 1860 TL
(4, 10, 1),
(4, 9, 2),

-- Siparis 5: 3950 TL
(5, 11, 1),
(5, 12, 1),

-- Siparis 6: 2150 TL
(6, 6, 1),
(6, 4, 1),

-- Siparis 7: 2150 TL
(7, 3, 1),
(7, 2, 2),

-- Siparis 8: 3000 TL
(8, 5, 1),
(8, 6, 1),

-- Siparis 9: 29750 TL
(9, 1, 1),
(9, 3, 1),

-- Siparis 10: 1750 TL
(10, 10, 1),
(10, 8, 1);

-- Eklenen siparis detaylarini listeleme
SELECT * FROM OrderDetails;





GO

-- BOLUM 2: Siparis tutarlarini kontrol etme
SELECT
    o.OrderID,
    o.TotalAmount AS KayitliTutar,
    SUM(od.Quantity * p.Price) AS HesaplananTutar,
    CASE
        WHEN o.TotalAmount = SUM(od.Quantity * p.Price)
        THEN 'DOGRU'
        ELSE 'HATALI'
    END AS Kontrol
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderID, o.TotalAmount
ORDER BY o.OrderID;




GO

-- BOLUM 3 - SORGU 1: Stok miktari 20'den az olan urunler
SELECT
    ProductName,
    Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;





GO

-- BOLUM 3 - SORGU 2: Musterilerin siparisleri
SELECT
    c.FullName AS MusteriAdi,
    c.City AS Sehir,
    o.OrderDate AS SiparisTarihi,
    o.TotalAmount AS ToplamTutar
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate ASC;




GO

-- BOLUM 3 - SORGU 3: Musterinin satin aldigi urunler
SELECT
    c.FullName AS MusteriAdi,
    p.ProductName AS UrunAdi,
    p.Price AS Fiyat,
    cat.CategoryName AS Kategori
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p
    ON od.ProductID = p.ProductID
INNER JOIN Categories cat
    ON p.CategoryID = cat.CategoryID
WHERE c.FullName = 'Ahmet Yilmaz';





GO

-- BOLUM 3 - SORGU 4: Kategorilere gore urun sayisi
SELECT
    c.CategoryName AS Kategori,
    COUNT(p.ProductID) AS UrunSayisi
FROM Categories c
LEFT JOIN Products p
    ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY UrunSayisi DESC;




GO

-- BOLUM 3 - SORGU 5: Musteri bazinda ciro analizi
SELECT
    c.FullName AS MusteriAdi,
    COALESCE(SUM(o.TotalAmount), 0) AS ToplamCiro
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY ToplamCiro DESC;




GO

-- BOLUM 3 - SORGU 6: Siparislerin uzerinden gecen gun sayisi
SELECT
    OrderID,
    OrderDate AS SiparisTarihi,
    GETDATE() AS BugununTarihi,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS GecenGun
FROM Orders
ORDER BY OrderDate ASC;




GO

-- BOLUM 4 - GOREV 1: Siparis ozeti VIEW olusturma
CREATE VIEW vw_SiparisOzet
AS
SELECT
    c.FullName AS MusteriAdi,
    o.OrderDate AS SiparisTarihi,
    p.ProductName AS UrunAdi,
    od.Quantity AS Adet
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p
    ON od.ProductID = p.ProductID;
GO

-- Olusturulan VIEW'i test etme
SELECT * FROM vw_SiparisOzet;





GO

-- BOLUM 4 - GOREV 2: Veritabani yedekleme
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH
    INIT,
    NAME = 'NovaStoreDB Full Backup',
    STATS = 10;

