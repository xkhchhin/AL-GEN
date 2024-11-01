page 50109 "Warehouse Entry Subpage"
{
    Caption = '';
    PageType = ListPart;
    SourceTable = "Warehouse Entry";
    ApplicationArea = all;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of units of the item in the warehouse entry.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the location to which the entry is linked.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = all;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
    var
        BinContentRec: Record "Bin Content";

    trigger OnAfterGetRecord()
    var
        WareEntry: Record "Warehouse Entry";
    begin
        // Filter Warehouse Entry records based on the Bin Content record
        ClearAll();
        WareEntry.SetRange("Location Code", BinContentRec."Location Code");
        WareEntry.SetRange("Bin Code", BinContentRec."Bin Code");
        WareEntry.SetRange("Item No.", BinContentRec."Item No.");
    end;

    trigger OnInit()
    begin
        // Ensure the page has access to the Bin Content record
        CurrPage.SetRecord(BinContentRec);
    end;
}
