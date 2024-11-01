page 50124 "Inventory Expiration Mgt List"
{
    ApplicationArea = All;
    Caption = 'Inventory Expiration Management List';
    PageType = List;
    SourceTable = "Inventory Expiration Mgt.";
    UsageCategory = Lists;
    Permissions = tabledata "Item Ledger Entry" = RMID;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item Expiration Category"; Rec."Item Expiration Category")
                {
                    ApplicationArea = All;
                }
                field("Write Off Range"; Rec."Write Off Range")
                {
                    ApplicationArea = All;
                }
                field("Threshold 1"; Rec."Threshold 1")
                {
                    ApplicationArea = All;
                }


                field("Low Range"; Rec."Low Range")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Low Range field.', Comment = '%';
                    StyleExpr = LowRangeStyleExprTxt;

                }
                field("Threshold 2"; Rec."Threshold 2")
                {
                    ApplicationArea = All;
                    StyleExpr = LowRangeStyleExprTxt;
                    ToolTip = 'Specifies the value of the threshold 1 field.', Comment = '%';
                }

                field("Middle Range"; Rec."Middle Range")
                {
                    StyleExpr = MiddleRangeStyleExprTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Middle Range field.', Comment = '%';
                }
                field("Threshold 3"; Rec."Threshold 3")
                {
                    StyleExpr = MiddleRangeStyleExprTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Threshold 2 field.', Comment = '%';
                }

                field("High Rang"; Rec."High Range")
                {
                    StyleExpr = HighRangeStyleExprTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the High Rang field.', Comment = '%';
                }
                field("Threshold 4"; Rec."Threshold 4")
                {
                    StyleExpr = HighRangeStyleExprTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Threshold 2 field.', Comment = '%';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = RefreshPlanningLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // trigger OnAction()
                // Var
                //     Refresh: Codeunit RefreshLotWithExpiration;
                // begin
                //     Refresh.RefreshEntries();
                // end;
            }
            action(ItemExpirationCategorySetup)
            {
                ApplicationArea = All;
                Caption = 'Item Expiration Category';
                Image = Category;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Item Expiration Category";
            }
            action("Generate Report")
            {
                ApplicationArea = All;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // trigger OnAction()
                // var
                //     InventoryExpiration: Report "Inventory Expiration (XTR)";
                // begin
                //     InventoryExpiration.Run();
                // end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        InventoryManagement: Record "Inventory Expiration Mgt.";
        LastEntryNo: Integer;
    begin
        InventoryManagement.Reset();
        LastEntryNo := 0;
        if InventoryManagement.FindLast()
        then
            LastEntryNo := InventoryManagement."Entry No." + 1;
        Rec."Entry No." := LastEntryNo;
        Rec.Modify(true);
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
        LowRangeStyleExprTxt := ChangeRankColor(Rec."Low Range");
        MiddleRangeStyleExprTxt := ChangeRankColor(Rec."Middle Range");
        HighRangeStyleExprTxt := ChangeRankColor(Rec."High Range");
        WriteOffRangeStyleExprTxt := ChangeRankColor(Rec."Write Off Range")
    end;

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

    var

        RangStyle: enum "Invt. Expiration Range Style";
        StyleOption: Option "None","Green","Red","Orange";
        LowRangeStyleExprTxt: Text[50];
        MiddleRangeStyleExprTxt: Text[50];
        HighRangeStyleExprTxt: Text[50];
        WriteOffRangeStyleExprTxt: Text[50];
}
