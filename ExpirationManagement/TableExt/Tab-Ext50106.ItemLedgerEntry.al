tableextension 50106 "Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50100; "New Bin Code Cust"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; OptionType; Enum OptionType)
        {
            Caption = 'Option Type';
            DataClassification = ToBeClassified;
        }
        field(50102; "Student Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Reclass to Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Reclass to Bin Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "test"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Item Expiration Category"; Code[20])
        {
            Caption = 'Item Expiration Category';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Expiration Category" where("No." = field("Item No.")));

        }
        field(50107; "Expiration Category Level"; Enum "Invt. Expiration Range Style")
        {
            Caption = 'Expiration Category Level';
            DataClassification = ToBeClassified;
        }
        field(50108; "No of Days (RcptDate-Today)"; Integer)
        {
            Caption = 'No of Days (Rcpt Date to Today)';
            DataClassification = ToBeClassified;
        }
        field(50109; "No of Days (Today-Exp. Date)"; Integer)
        {
            Caption = 'No of Days (Today to Expiration Date)';
            DataClassification = ToBeClassified;
        }
    }
}
