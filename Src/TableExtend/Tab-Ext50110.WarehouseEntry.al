tableextension 50110 "Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        field(50100; "test"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';

            FieldClass = FlowField;

            CalcFormula = lookup("Item Ledger Entry"."Remaining Quantity" where("Document No." = field("Reference No."), "Item No." = field("Item No."),

            "Document Line No." = field("Source Line No."), "Location Code" = field("Location Code")));
        }
    }
}
