pageextension 50107 AssemblyOrder extends "Assembly Orders"
{
    layout
    {
        // Add changes to page layout here
        modify(Quantity)
        {
            ApplicationArea = all;
            Editable = false;
        }
        modify("Variant Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            // action(Import)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Import (Chhein)', comment = '="YourLanguageCaption"';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = ImportExcel;

            //     trigger OnAction()
            //     begin
            //         ReadExcelSheetHeaderAndLine();
            //     end;
            // }
            // action(Export)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Export(Chhein)', comment = '="YourLanguageCaption"';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = ExportToExcel;
            //     //Visible = ImportVisible;

            //     trigger OnAction()
            //     var
            //         ExportAssorder: Report "Assembly Order Export";
            //     begin
            //         ExportAssorder.Run();
            //     end;
            // }
            // action(Delete)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Delete(chhein)', comment = '="YourLanguageCaption"';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = Delete;

            //     trigger OnAction()
            //     begin
            //         DeleteAssemblyHeader();
            //     end;
            // }
        }
    }
    local procedure DeleteAssemblyHeader()
    var
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
    begin
        AssemblyHeader.Reset();
        AssemblyLine.Reset();
        if AssemblyHeader.FindFirst() then begin
            AssemblyHeader.DeleteAll();
        end;
        if AssemblyLine.FindFirst() then begin
            AssemblyLine.DeleteAll();
        end;
        Message(DeleteAssemblyHeaderMss);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExelBuffer.Reset();
        if TempExelBuffer.get(RowNo, ColNo) then
            exit(TempExelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ReadExcelSheetHeaderAndLine()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        NameValueBufferOut: Record "Name/Value Buffer" temporary;
        FromFile: Text[100];
        MaxRow: Integer;
        ColNo: Integer;
        RowNo: Integer;
    begin
        SheetName := '';
        FileName := '';
        UploadIntoStream(UploadMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            TempExelBuffer.GetSheetsNameListFromStream(IStream, NameValueBufferOut);
        end else
            Error(NoFileMsg);
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        NameValueBufferOut.Reset();
        if NameValueBufferOut.FindSet() then begin
            repeat
                Clear(SheetName);
                SheetName := NameValueBufferOut.Value;
                TempExelBuffer.OpenBookStream(IStream, SheetName);
                TempExelBuffer.ReadSheet();

                MaxRow := 0;
                TempExelBuffer.Reset();
                if TempExelBuffer.FindLast() then
                    MaxRow := TempExelBuffer."Row No.";

                ColNo := 0;
                RowNo := 0;

                IF SheetName = AssemblyLineLbl THEN
                    ImportExcelDataLine();
                IF SheetName = AssemblyHeaderLbl THEN
                    ImportExcelDataHeader();
            until NameValueBufferOut.Next() = 0;
        end;
    end;

    local procedure ReadExcelAssemblyHeader()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[10];
    begin
        UploadIntoStream(UploadMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExelBuffer.SelectSheetsNameStream(Istream);

        end else
            Error(NoFileMsg);
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.OpenBookStream(Istream, SheetName);
        TempExelBuffer.ReadSheet();
        ImportExcelDataHeader();
    end;

    local procedure ReadExcelAssemblyLine()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[10];
    begin
        UploadIntoStream(UploadMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExelBuffer.SelectSheetsNameStream(Istream);

        end else
            Error(NoFileMsg);
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.OpenBookStream(Istream, SheetName);
        TempExelBuffer.ReadSheet();
        ImportExcelDataLine();
    end;

    local procedure ImportExcelDataHeader()
    var
        ASSHeaderImportBuffer: Record "Assembly Header";
        ASSLineImportBuffer: Record "Assembly Line";
        RowNo: Integer;
        ColNo: Integer;
        No: code[20];
        Description: Text[250];
        LineNo: Integer;
        MaxRowNo: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        Qty: Decimal;
        UOM: Code[10];
        I: Integer;
        InvoiceNo: Code[24];
        DocNo: code[24];
        ProgressMsg: Label 'ASSembly Header Importing\Invoice No.: #1#####\Record Count: #2#####\Total Records Counted: #3#####';

    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        ASSHeaderImportBuffer.Reset();
        TempExelBuffer.Reset();
        if TempExelBuffer.FindLast() then begin
            MaxRowNo := TempExelBuffer."Row No.";
        end;
        if TempExelBuffer.FindSet() then
            RecordCounted := TempExelBuffer.Count;
        Progress.OPEN(ProgressMsg, ASSHeaderImportBuffer."No.", Counter, RecordCounted);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin
            Evaluate(Description, GetValueAtCell(RowNo, 4));
            Evaluate(DocNo, GetValueAtCell(RowNo, 3));
            Evaluate(Qty, GetValueAtCell(RowNo, 9));

            Counter := Counter + 1;//update dialog
            LineNo := LineNo + 10000;
            ASSHeaderImportBuffer.SetRange("No.", DocNo);
            if not ASSHeaderImportBuffer.Find('-') then begin
                ASSHeaderImportBuffer.Init();
                Evaluate(ASSHeaderImportBuffer."Document Type", GetValueAtCell(RowNo, 1));
                Evaluate(ASSHeaderImportBuffer."Item No.", GetValueAtCell(RowNo, 2));
                Evaluate(ASSHeaderImportBuffer."No.", GetValueAtCell(RowNo, 3));
                Evaluate(ASSHeaderImportBuffer.Description, GetValueAtCell(RowNo, 4));
                Evaluate(ASSHeaderImportBuffer."Due Date", GetValueAtCell(RowNo, 5));
                Evaluate(ASSHeaderImportBuffer."Starting Date", GetValueAtCell(RowNo, 6));
                Evaluate(ASSHeaderImportBuffer."Ending Date", GetValueAtCell(RowNo, 7));
                Evaluate(ASSHeaderImportBuffer."Assemble to Order", GetValueAtCell(RowNo, 8));
                Evaluate(ASSHeaderImportBuffer.Quantity, GetValueAtCell(RowNo, 9));
                Evaluate(ASSHeaderImportBuffer."Quantity to Assemble", GetValueAtCell(RowNo, 10));
                Evaluate(ASSHeaderImportBuffer."Unit Cost", GetValueAtCell(RowNo, 11));
                Evaluate(ASSHeaderImportBuffer."Unit of Measure Code", GetValueAtCell(RowNo, 12));
                Evaluate(ASSHeaderImportBuffer."Location Code", GetValueAtCell(RowNo, 13));
                Evaluate(ASSHeaderImportBuffer."Variant Code", GetValueAtCell(RowNo, 14));
                Evaluate(ASSHeaderImportBuffer."Bin Code", GetValueAtCell(RowNo, 15));
                Evaluate(ASSHeaderImportBuffer."Remaining Quantity", GetValueAtCell(RowNo, 16));
                Evaluate(ASSHeaderImportBuffer."Posting Date", GetValueAtCell(RowNo, 17));
                Evaluate(ASSHeaderImportBuffer."Posting No.", GetValueAtCell(RowNo, 18));
                ASSHeaderImportBuffer.Insert();
                ASSHeaderImportBuffer.Validate("Item No.", GetValueAtCell(RowNo, 2));
                ASSHeaderImportBuffer.Validate("Posting No.", GetValueAtCell(RowNo, 18));
                ASSHeaderImportBuffer.Validate("Posting Date");
                ASSHeaderImportBuffer.Validate(Quantity, Qty);
                ASSHeaderImportBuffer.Validate("Unit of Measure Code", GetValueAtCell(RowNo, 12));
                ASSHeaderImportBuffer.validate("Gen. Prod. Posting Group", GetASSHe(GetValueAtCell(RowNo, 2)));
                Progress.UPDATE(); // Update the field in the dialog. 
                ASSHeaderImportBuffer.Modify(true);
            end else begin
                //Modify

                ASSLineImportBuffer.validate(Description, Description);
                ASSHeaderImportBuffer.Modify(true);
                Progress.UPDATE(); // Update the field in the dialog. 
            end;


        end;
        Progress.CLOSE();
        Message('Total Assembly Header Imported = %1', Counter);
    end;

    local procedure ImportExcelDataLine()
    var
        ASSLineImportBuffer: Record "Assembly Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        LineType: Option "Item","G/L Account";
        No: Code[50];
        Description: Text[250];
        DocNo: Code[50];
        UnitPrice: Decimal;
        UnitCost: Decimal;
        LineQty: Decimal;
        UOM: Code[24];
        LineDiscountAmount: Decimal;
        ShortCutDim1: Code[50];
        ShortCutDim2: Code[50];
        DocumentType: Option "Invoice";
        LocationCode: Code[50];
        GeneralProductPostingGroup: Code[50];
        //dialog
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Importing Assembly Line No.: #1#####\No.: #2#####\Record Count: #3#####';
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        ASSLineImportBuffer.Reset();
        TempExelBuffer.Reset();
        if TempExelBuffer.FindLast() then begin
            MaxRowNo := TempExelBuffer."Row No.";
        end;
        if TempExelBuffer.FindSet() then
            RecordCounted := TempExelBuffer.Count;
        Progress.OPEN(ProgressMsg, ASSLineImportBuffer."Document No.", ASSLineImportBuffer."No.", Counter);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin
            DocNo := GetValueAtCell(RowNo, 1);

            Evaluate(DocNo, GetValueAtCell(RowNo, 1));
            Evaluate(LineNo, GetValueAtCell(RowNo, 2));
            Evaluate(No, GetValueAtCell(RowNo, 4));
            Evaluate(Description, GetValueAtCell(RowNo, 5));
            //Evaluate(DocumentType, GetValueAtCell(RowNo, 17));
            Evaluate(GeneralProductPostingGroup, GetValueAtCell(RowNo, 14));

            Counter := Counter + 1;//update dialog


            if ASSLineImportBuffer.FindLast() then
                LineNo := ASSLineImportBuffer."Line No." + 10000
            else
                LineNo := 10000;

            ASSLineImportBuffer.SetRange("Document No.", DocNo);
            ASSLineImportBuffer.SetRange("Line No.", LineNo);
            ASSLineImportBuffer.SetRange("No.", No);
            //ASSLineImportBuffer.SetRange("Document Type", DocumentType);

            if not ASSLineImportBuffer.Find('-') then begin

                ASSLineImportBuffer.Init();
                ASSLineImportBuffer."Line No." := LineNo;
                Evaluate(ASSLineImportBuffer."Document No.", GetValueAtCell(RowNo, 1));
                Evaluate(ASSLineImportBuffer."Line No.", GetValueAtCell(RowNo, 2));
                Evaluate(ASSLineImportBuffer."Type", GetValueAtCell(RowNo, 3));
                Evaluate(ASSLineImportBuffer."No.", GetValueAtCell(RowNo, 4));
                Evaluate(ASSLineImportBuffer.Description, GetValueAtCell(RowNo, 5));
                Evaluate(ASSLineImportBuffer."Variant Code", GetValueAtCell(RowNo, 6));
                Evaluate(ASSLineImportBuffer."Quantity per", GetValueAtCell(RowNo, 7));
                Evaluate(ASSLineImportBuffer.Quantity, GetValueAtCell(RowNo, 8));
                Evaluate(ASSLineImportBuffer."Quantity to Consume", GetValueAtCell(RowNo, 9));
                Evaluate(ASSLineImportBuffer."Location Code", GetValueAtCell(RowNo, 10));
                Evaluate(ASSLineImportBuffer."Unit Cost", GetValueAtCell(RowNo, 11));
                Evaluate(ASSLineImportBuffer."Unit of Measure Code", GetValueAtCell(RowNo, 12));
                Evaluate(ASSLineImportBuffer."Cost Amount", GetValueAtCell(RowNo, 13));
                // Evaluate(ASSLineImportBuffer."Gen. Prod. Posting Group", GetValueAtCell(RowNo, 14));
                Evaluate(ASSLineImportBuffer."Document Type", GetValueAtCell(RowNo, 17));
                ASSLineImportBuffer.Insert();
                ASSLineImportBuffer.validate("Gen. Prod. Posting Group", GetASSLi(GetValueAtCell(RowNo, 4)));

                ASSLineImportBuffer.Modify(true);
                Progress.UPDATE(); // Update the field in the dialog. 
            end else begin
                ASSLineImportBuffer.validate(Description, Description);
                ASSLineImportBuffer.Modify(true);
                Progress.UPDATE(); // Update the field in the dialog. 
            end;
        end;
        Progress.Close();
        Message('Total Assembly Lines Imported = %1', Counter);
    end;

    local procedure GetASSHe(GenProdPostGro: code[20]): Text
    var
        item: Record Item;
        Gen: Code[20];
    begin
        item.Reset();
        item.SetRange("No.", GenProdPostGro);
        if item.Find('-') then
            //Gen := item."Gen. Prod. Posting Group";
            exit(item."Gen. Prod. Posting Group");
    end;

    local procedure GetASSLi(GenProdPostGro: code[20]): Text
    var
        item: Record Item;
        Gen: Code[20];
    begin
        item.Reset();
        item.SetRange("No.", GenProdPostGro);
        if item.Find('-') then
            //Gen := item."Gen. Prod. Posting Group";
            exit(item."Gen. Prod. Posting Group");
    end;

    var
        ImportVisible: Boolean;
        myInt: Integer;
        ImportMess: Label 'Import Action';
        ExportMess: Label 'Export Action';
        FileName: Text[100];
        SheetName: Text[100];
        TempExelBuffer: Record "Excel Buffer" temporary;
        UploadMsg: Label 'Please Choose The Excel File';
        NoFileMsg: Label 'No Excel File Found';
        ExcelImportSuccess: Label 'Excel Import Success';
        ImaportBufferAssemblyHeaderTbl: Record "Assembly Header";
        ImaportBufferAssemblyLineTbl: Record "Assembly Line";
        DeleteAssemblyHeaderMss: Label 'Assembly Record Has Been Deleted.';
        ExcelHeaderImportSucess: Label 'Assembly Header with document is successfully imported.';
        ExcelLineImportSucess: Label 'Assembly Line with document is successfully imported.';
        AssemblyLineLbl: Label 'Assembly Line';
        AssemblyHeaderLbl: Label 'Assembly Header';
}