pageextension 50118 "Item Journal Lines" extends "Item Journal"
{
    layout
    {
        addafter(Quantity)
        {
            field(OptionType; Rec.OptionType)
            {
                ApplicationArea = all;
            }
        }
        addafter("Bin Code")
        {
            field("Reclass to Location Code"; Rec."Reclass to Location Code")
            {
                ApplicationArea = all;
            }
            field("Reclass to Bin Code"; Rec."Reclass to Bin Code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Line")
        {
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
    procedure CreateItemJournalPositiveAdjustment(Var JournalTemplate: Code[20]; JournalBatch: code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        TempJournalLine: Record "Item Journal Line" temporary;
        LastLineNo: Integer;
    begin
        if ItemJournalLine.FindLast() then
            LastLineNo := ItemJournalLine."Line No.";

        if ItemJournalLine.FindSet() then begin
            repeat
                TempJournalLine := ItemJournalLine;
                TempJournalLine.Insert();
            until ItemJournalLine.Next() = 0;
        end;

        // Now insert each line from the temporary record below the existing lines
        if TempJournalLine.FindSet() then begin
            repeat
                LastLineNo += 10000; // Increment the line number for the new line
                TempJournalLine."Line No." := LastLineNo;
                ItemJournalLine := TempJournalLine;
                ItemJournalLine.Insert();
            until TempJournalLine.Next() = 0;
        end;
    end;
}
