table 50105 VendorTbl
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Contact; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Balance (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Balance Due (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Payments (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}