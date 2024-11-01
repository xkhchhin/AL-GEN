page 50105 "Item ReclassificationCustom"
{
    ApplicationArea = All;
    Caption = 'Item Reclassification Custom';
    PageType = Worksheet;
    SourceTable = "Item Journal Line";
    UsageCategory = Tasks;
    SaveValues = true;
    //
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item on the journal line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the item on the journal line.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the inventory location where the item on the journal line will be registered.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a bin code for the item.';
                }
                field("Reclass to Location Code"; Rec."Reclass to Location Code")
                {
                    ApplicationArea = all;
                }
                field("Reclass to Bin Code"; Rec."Reclass to Bin Code")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of units of the item to be included on the journal line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("New Shortcut Dimension 1 Code"; Rec."New Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new dimension value code that will link to the items on the journal line.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Post")
            {
                ApplicationArea = All;
                RunObject = Codeunit "Item Jnl.-Post";
                Image = PostDocument;
            }
            action(Add)
            {
                ApplicationArea = All;
                Caption = 'Add', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Add;

                trigger OnAction()
                begin
                    //CreateReclass();
                    CreateItemJournalPositiveAdjustment(rec."Journal Template Name", rec."Journal Batch Name")
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetRange("Journal Template Name", 'ITEM');
        rec.SetRange("Journal Batch Name", 'Default');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lineno: Integer;
    begin
        Rec.SetUpNewLine(xRec);
        //Rec."Entry Type" := Rec."Entry Type"::"Positive Adjmt.";
    end;

    procedure CreateItemJournalPositiveAdjustment(Var JournalTemplate: Code[20]; JournalBatch: code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        SourceLine: Record "Item Journal Line";
        OriginalLineNo: Integer;
        NewLineNo: Integer;
    begin
        if ItemJournalLine.FindLast() then
            OriginalLineNo := ItemJournalLine."Line No.";

        // Loop through all lines and copy them
        if ItemJournalLine.FindSet() then begin
            repeat
                SourceLine := ItemJournalLine;
                if ItemJournalLine.FindLast() then
                    NewLineNo := OriginalLineNo + 10000
                else
                    NewLineNo := 10000;

                // Insert new line below the existing ones
                ItemJournalLine.Init();
                ItemJournalLine.TransferFields(SourceLine);
                ItemJournalLine."Line No." := NewLineNo;
                ItemJournalLine.Insert();
            until ItemJournalLine.Next() = 0;
        end;
    end;
}
