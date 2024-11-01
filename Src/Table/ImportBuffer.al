table 50100 ImportBuffer
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Batch Name"; code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; File_Name; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Sheet Name"; text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Imported_Date; date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Imported_Time; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Sell-to Customer No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Posting_Date; date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Currency_Code; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Document_Date; date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "External Document No."; code[35])
        {
            DataClassification = ToBeClassified;
        }

        field(14; "No."; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Quantity; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Unit Price"; code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Batch Name", "Line No.", "Document No.")
        {
            Clustered = true;
        }

    }

    var

}