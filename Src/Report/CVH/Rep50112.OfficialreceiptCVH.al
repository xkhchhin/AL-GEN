report 50112 OfficialreceiptCVH
{
    Caption = 'Official Receipt CVH';
    RDLCLayout = './LayoutReport/OfficialReceipt.rdl';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Document No.") WHERE("Document Type" = CONST(Payment));
            RequestFilterFields = "Document No.", "Sell-to Customer No.", "Posting Date";
            RequestFilterHeading = 'Cust. Ledger Entries';

            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddre; CompanyInfo.Address)
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(Customer_No_; "Customer No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Bal__Account_No_; "Bal. Account No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_No_; "Document No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Document_Type; "Document Type") { }
            column(Description; Description) { }
            column(Currency_Code; "Currency Code") { }
            column(Amount; Amount) { }
            column(Customer_Posting_Group; "Customer Posting Group") { }
            dataitem(DetailedCustLedgEntry1; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Applied Cust. Ledger Entry No." = FIELD("Entry No.");
                DataItemLinkReference = CustLedgerEntry;
                DataItemTableView = SORTING("Applied Cust. Ledger Entry No.", "Entry Type") WHERE(Unapplied = CONST(false));
                dataitem(CustLedgEntry1; "Cust. Ledger Entry")
                {
                    DataItemLink = "Entry No." = FIELD("Cust. Ledger Entry No.");
                    DataItemLinkReference = DetailedCustLedgEntry1;
                    DataItemTableView = SORTING("Entry No.");
                    column(PostDate_CustLedgEntry1; Format("Posting Date"))
                    {
                    }
                    column(DocType_CustLedgEntry1; "Document Type")
                    {
                        IncludeCaption = true;
                    }
                    column(DocumentNo_CustLedgEntry1; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_CustLedgEntry1; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(CurrCode_CustLedgEntry1; CurrencyCode("Currency Code"))
                    {
                    }

                    column(CurrencyCodeCaption; FieldCaption("Currency Code"))
                    {
                    }


                }
            }
        }


    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
    end;

    trigger OnPreReport()
    begin

        CompanyInfo.Reset();
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.Get();
        GLSetup.Get();
    end;

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code");
        exit(SrcCurrCode);
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[100];
        GLSetup: Record "General Ledger Setup";

}
