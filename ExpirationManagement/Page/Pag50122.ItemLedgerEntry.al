page 50122 "Item Ledger Entry"
{
    Caption = 'Nearest Expiration Date';
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field(Description; GetItemDescription(rec."Item No."))
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date that the item on the line can be used.';
                }
                field("No of Days (Today-Exp. Date)"; Rec."No of Days (Today-Exp. Date)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No of Days (Today to Expiration Date) field.', Comment = '%';
                }
                field("Item Expiration Category"; Rec."Item Expiration Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Expiration Category field.', Comment = '%';
                }
                field("Expiration Category Level"; Rec."Expiration Category Level")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiration Category Level field.', Comment = '%';
                    StyleExpr = RangeStyleExprTxt;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SetFilter("Lot No.", '<>%1', '');
    end;

    local procedure GetItemDescription(ItemNo: Code[20]): Text[100]
    var
        Item: Record Item;
    begin
        Item.Reset();
        Item.SetRange("No.", ItemNo);
        if Item.Find('-') then
            exit(Item.Description);
    end;

    procedure ChangeRankColor(RangStyle: enum "Invt. Expiration Range Style"): Text[50]
    var
        myInt: Integer;
    begin
        case RangStyle of
            RangStyle::Red:
                exit('Unfavorable');
            RangStyle::Green:
                exit('Favorable');
            RangStyle::Orange:
                exit('Ambiguous');
            RangStyle::None:
                exit('Subordinate');
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        RangeStyleExprTxt := ChangeRankColor(Rec."Expiration Category Level");
    end;

    var

        RangStyle: enum "Invt. Expiration Range Style";
        StyleOption: Option "None","Green","Red","Orange";
        RangeStyleExprTxt: Text[50];
}
