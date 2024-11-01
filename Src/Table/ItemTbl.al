table 50106 ItemTbl
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Search Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Inventory"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Base Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Vendor No."; Code[20])
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