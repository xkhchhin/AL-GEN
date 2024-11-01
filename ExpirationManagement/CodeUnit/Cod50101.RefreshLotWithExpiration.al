codeunit 50101 RefreshLotWithExpiration
{
    TableNo = "Item Ledger Entry";

    trigger OnRun()
    begin
        RefreshEntries();
    end;

    procedure RefreshEntries()
    var
        InvtExpMgt: Record "Inventory Expiration Mgt.";
        NoOfDay: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Progress: Dialog;
        ProgressMsg: Label 'Refreshing Item Ledger Entries\Working on Entry.: #1#####\Record Counted.: #2#####\Counter.: #3#####';
        Counter: Integer;
        RecordCounted: Integer;
    begin
        Counter := 0;
        RecordCounted := 0;
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetFilter("Expiration Date", '>%1', 0D);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        RecordCounted := ItemLedgerEntry.Count;
        Progress.OPEN(ProgressMsg, ItemLedgerEntry."Entry No.", RecordCounted, Counter);//progress dialog open
        if ItemLedgerEntry.FindSet()
        then
            repeat
                Counter := Counter + 1;
                NoOfDay := 0;
                ItemLedgerEntry.CalcFields("Item Expiration Category");
                // if (ItemLedgerEntry."Expiration Date" > 0D) and (ItemLedgerEntry."Remaining Quantity" > 0) then begin
                ItemLedgerEntry."No of Days (RcptDate-Today)" := ABS(Today - ItemLedgerEntry."Posting Date");
                ItemLedgerEntry."No of Days (Today-Exp. Date)" := ItemLedgerEntry."Expiration Date" - Today();
                NoOfDay := ItemLedgerEntry."Expiration Date" - Today();
                InvtExpMgt.Reset();
                InvtExpMgt.SetRange("Item Expiration Category", ItemLedgerEntry."Item Expiration Category");
                if InvtExpMgt.Find('-') then
                    case NoOfDay of//writeoff
                        -9999 .. InvtExpMgt."Threshold 1":
                            begin
                                ItemLedgerEntry."Expiration Category Level" := InvtExpMgt."Write Off Range";
                            end;
                        (InvtExpMgt."Threshold 1" + 1) .. InvtExpMgt."Threshold 2":
                            begin
                                ItemLedgerEntry."Expiration Category Level" := InvtExpMgt."Low Range";
                            end;
                        (InvtExpMgt."Threshold 2" + 1) .. InvtExpMgt."Threshold 3":
                            begin
                                ItemLedgerEntry."Expiration Category Level" := InvtExpMgt."Middle Range";
                            end;
                        (InvtExpMgt."Threshold 3" + 1) .. InvtExpMgt."Threshold 4":
                            begin
                                ItemLedgerEntry."Expiration Category Level" := InvtExpMgt."High Range";
                            end;
                        else
                            ItemLedgerEntry."Expiration Category Level" := ItemLedgerEntry."Expiration Category Level"::" ";
                    end;
                ItemLedgerEntry.Modify(true);
                // end;
                Progress.Update();
                Sleep(10);
            until ItemLedgerEntry.Next() = 0;
        Progress.Close();
        //  Message('Total item ledger entries refreshed= %1', Counter);
    end;
}
