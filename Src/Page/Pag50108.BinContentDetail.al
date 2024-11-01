page 50108 "Bin Content Detail"
{
    Caption = 'Bin Content Detail';
    ApplicationArea = all;
    InsertAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Bin Content";
    UsageCategory = Tasks;
    Editable = false;

    layout
    {
        area(Content)
        {
            group("Bin Content Detail")
            {
                repeater(General)
                {
                    field("Location Code"; Rec."Location Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the location code of the bin.';
                    }
                    field("Bin Code"; Rec."Bin Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the bin where the items are picked or put away.';
                    }
                    field("Item No."; Rec."Item No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of the item that will be stored in the bin.';
                    }

                    field("Unit of Measure Code"; Rec."Unit of Measure Code")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    }
                    field("Quantity (Base)"; Rec."Quantity (Base)")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                    }
                }
            }
            group("")
            {
                part(WarehouseEntrySubpage; "Warehouse Entry Subpage")
                {
                    ApplicationArea = All;
                    SubPageLink = "Location Code" = FIELD("Location Code"),
                                  "Bin Code" = FIELD("Bin Code"),
                                  "Item No." = FIELD("Item No.");
                }
            }
        }
    }
    var
        //WarehouseEntry: Record "Warehouse Entry";
        WarehouseEntryQuantity: Decimal;

    trigger OnAfterGetRecord()
    begin
        // Find the Warehouse Entry related to this Bin Content record
        // if WarehouseEntry.Get(Rec."Location Code", Rec."Bin Code", Rec."Item No.") then begin
        //     WarehouseEntryQuantity := WarehouseEntry.Quantity;
        // end else begin
        //     WarehouseEntryQuantity := 0;
        // end;
    end;
}
