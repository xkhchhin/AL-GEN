report 50110 "Serial No. Information Report"
{
    ApplicationArea = All;
    Caption = 'Serial No. Info Export Tool';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Serial No. Information"; "Serial No. Information")
        {
            RequestFilterFields = "Item No.";
            column(Item_No_; "Item No.")
            {

            }
            trigger OnAfterGetRecord()
            begin
                ExportToExcel("Serial No. Information");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Export)
                {
                    // field(Name; "Item No.")
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    local procedure ExportToExcel(var SerialNoInfo: Record "Serial No. Information")
    var
        ExcelBufferTmp: Record "Excel Buffer" temporary;
        GSExcelLbl: Label 'GS Excel Item';
        GSFileName: Label 'GS Excel Item_%1_%2';
        Counter: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        I: Integer;
        ProgressMsg: Label 'Processing Serial No. Information: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin
        RecordCounted := "Serial No. Information".Count;
        Progress.OPEN(ProgressMsg, "Serial No. Information"."Item No.", Counter, RecordCounted);//progress dialog open

        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelBufferTmp.NewRow();

        ExcelBufferTmp.AddColumn(SerialNoInfo.FieldCaption("Item No."), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(SerialNoInfo.FieldCaption("Serial No."), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(SerialNoInfo.FieldCaption("Variant Code"), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(SerialNoInfo.FieldCaption(Description), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);


        if SerialNoInfo.FindSet() then
            repeat
                Counter := Counter + 1;//update dialog
                ExcelBufferTmp.NewRow();
                ExcelBufferTmp.AddColumn(SerialNoInfo."Item No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(SerialNoInfo."Serial No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(SerialNoInfo."Variant Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(SerialNoInfo.Description, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                Progress.UPDATE(); // Update the field in the dialog. 
                SLEEP(50);
            until SerialNoInfo.Next() = 0;

        ExcelBufferTmp.CreateNewBook(GSExcelLbl);
        ExcelBufferTmp.WriteSheet(GSExcelLbl, CompanyName, UserId);
        ExcelBufferTmp.CloseBook();
        ExcelBufferTmp.SetFriendlyFilename(StrSubstNo(GSFileName, CurrentDateTime, UserId));
        ExcelBufferTmp.OpenExcel();
        Progress.CLOSE();
        Message('Total Serial No. Info Exported = %1', Counter);
    end;

    var
        myInt: Integer;
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelSerialNoImportSucess: Label 'Serial No. Information with document is successfully imported.';
        SerialNoInfoLbl: Label 'Serial No. Information';
}