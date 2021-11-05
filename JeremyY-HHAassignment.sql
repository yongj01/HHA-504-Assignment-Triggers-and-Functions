use synthea;
show tables;

select * from clinical_data;

## Creating a trigger to reject diastolic BP over 100 mg

delimiter $$

CREATE TRIGGER qualityDiastolic BEFORE INSERT ON clinical_data
FOR EACH ROW
BEGIN
IF NEW.diastolic >= 100 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ERROR: Diastolic BP MUST BE BELOW 100 mg!';
END IF;
END; $$
Delimiter

INSERT INTO clinical_data (patientUID, lastname, systolic,
diastolic) VALUES (12345, 'Jeremy', 120, 170);

## Returned "Error Code: 1644. ERROR: Diastolic BP MUST BE BELOW 100 mg!"

INSERT INTO clinical_data (patientUID, lastname, systolic,
diastolic) VALUES (343434333, 'Jeremy', 320, 170);

## Returned "Error Code: 1644. ERROR: Systolic BP MUST BE BELOW 300 mg!"

## Creating a function

DELIMITER $$

CREATE FUNCTION TotalMedCost(cost decimal (10,2))
RETURNS varchar(20)
deterministic
BEGIN
	DECLARE totalcost VARCHAR(20);
	IF totalcost >= 1000 THEN
		SET totalmedcost = "expensive";
	ELSEIF (totalcost <1000 ) THEN
		SET totalmedcost = 'cheap';
	END IF;
    -- return the total cost category
	RETURN (totalcost);
END
$$

SELECT

Description,

totalcost,

totalmedcost(total_COST)

FROM

medications;

