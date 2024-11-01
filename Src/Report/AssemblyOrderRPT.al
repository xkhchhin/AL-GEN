report 50109 "Assembly Order Export"
{
    Caption = 'Assembly Order Export';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Assembly Header"; "Assembly Header")
        {
            //RequestFilterFields = "Posting Date", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(No; "No.")
            {
            }
            dataitem("Assembly Line"; "Assembly Line")
            {
                DataItemLinkReference = "Assembly Header";
                DataItemLink = "Document No." = field("No.");
                RequestFilterFields = "Document No.";

                column(Document_No_; "Document No.") { }
                trigger OnAfterGetRecord()
                begin
                    //SetRange(Posting, "Assembly Header"."Posting Date");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                ExportToExcel("Assembly Header", "Assembly Line");
            end;
        }

    }
    requestpage
    {
        SaveValues = true;
        layout
        {

            area(content)
            {
                group(Export)
                {
                    field(ToCompany; ToCompany)
                    {
                        ApplicationArea = All;
                        Caption = 'From Company';
                        Editable = false;
                    }
                }

            }
        }
    }
    local procedure ExportToExcel(var AssemblyHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Assembly Header';
        ExcelFileName: Label 'Assembly Template Export_%1__%2';
        TempExcelBufferLine: Record "Excel Buffer" temporary;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Processing Assembly Order: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin
        RecordCounted := "Assembly Header".Count;
        Progress.OPEN(ProgressMsg, "Assembly Header"."No.", Counter, RecordCounted);//progress dialog open
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Document Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Due Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Starting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Ending Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Assemble to Order"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption(Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Variant Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Bin Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyHeader.FieldCaption("Remaining Quantity"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        if AssemblyHeader.Find('-') then
            repeat
                Counter := Counter + 1;//update dialog

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(AssemblyHeader."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."Due Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(AssemblyHeader."Starting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(AssemblyHeader."Ending Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."Assemble to Order", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(AssemblyHeader."Variant Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."Bin Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyHeader."Remaining Quantity", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                Progress.UPDATE(); // Update the field in the dialog. 
                SLEEP(50);
            until AssemblyHeader.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet('Assembly Header', CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();

        //Export Lines
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption(Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('Assembly Orders No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption(Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Unit of Measure Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Cost Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Gen. Prod. Posting Group"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Shortcut Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssemblyLine.FieldCaption("Shortcut Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        if AssemblyLine.Find('-') then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(AssemblyLine.Type, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                //TempExcelBuffer.AddColumn('Assembly Orders No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                TempExcelBuffer.AddColumn(AssemblyLine."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyLine.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(AssemblyLine."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(AssemblyLine."Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(AssemblyLine."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyLine."Cost Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(AssemblyLine."Gen. Prod. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyLine."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AssemblyLine."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until AssemblyLine.Next() = 0;
        TempExcelBuffer.SelectOrAddSheet(AssemblyLineLbl);
        TempExcelBuffer.WriteSheet(AssemblyLineLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
        Progress.CLOSE();
        Message('Total Assembly Exported = %1', Counter);
    end;

    var
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelHeaderImportSucess: Label 'Assembly Header with document is successfully imported.';
        ExcelLineImportSucess: Label 'Assembly Line with document is successfully imported.';
        AssemblyLineLbl: Label 'Assembly Line';
        AssemblyHeaderLbl: Label 'Assembly Header';
}