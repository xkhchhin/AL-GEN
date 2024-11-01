tableextension 50100 SaleOrderLine extends "Sales Line"
{
    fields
    {
        field(50100; TID; Text[100])
        {
            Caption = 'TID';
            DataClassification = ToBeClassified;
        }
        field(50101; "Student Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "test"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}
