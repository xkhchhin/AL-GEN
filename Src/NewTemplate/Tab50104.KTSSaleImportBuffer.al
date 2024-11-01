table 50104 KTSSaleImportBuffer
{
    Caption = 'KTSSaleImportBuffer';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
        }
        field(4; "Sell-To Customer Name"; Text[100])
        {
            Caption = 'Sell-To Customer Name';
        }
        field(5; "Item No."; Code[10])
        {
            Caption = 'Item No.';
        }
        field(6; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }

        field(8; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(9; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(10; "Bin Code"; Code[50])
        {
            Caption = 'Bin Code';
        }
        field(11; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(12; "Transaction ID"; Code[50])
        {
            Caption = 'Transaction ID';
        }
        field(13; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
        }
        field(14; Department; Code[20])
        {
            Caption = 'Department';
        }
        field(15; "Sales Person Code"; Code[20])
        {
            Caption = 'Sales Person Code';
        }
        field(16; "External Document No."; Code[24])
        {
            Caption = 'External Document No.';
        }
        field(17; Remark; Text[100])
        {
            Caption = 'Remark';
        }
        field(18; Type; code[20])
        {
            Caption = 'Type';
        }
        field(19; QtyToSell; Decimal)
        {
            Caption = 'Qty To Sell';
        }
        field(50011; "Saled Item"; Boolean)
        {
            Caption = 'Saled Item';
        }
        field(5001; "Line No."; Integer)
        {
            // Caption = 'Saled Item';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Item No.", "Serial No.")
        {
            Clustered = true;
        }
    }
}
