#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 32 "VAT Registration No. Check"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Registration No. Check.rdlc';
    Caption = 'Tax Registration No. Check';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            column(ReportForNavId_5444; 5444)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(VAT_Registration_No__CheckCaption;VAT_Registration_No__CheckCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem(Integer2;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_4152; 4152)
                {
                }
                column(Format_ErrorsCaption;Format_ErrorsCaptionLbl)
                {
                }
                dataitem(Customer;Customer)
                {
                    DataItemTableView = sorting("No.") where("VAT Registration No."=filter(<>''));
                    column(ReportForNavId_6836; 6836)
                    {
                    }
                    column(Customer__No__;"No.")
                    {
                    }
                    column(Customer_Name;Name)
                    {
                    }
                    column(Customer__Country_Region_Code_;"Country/Region Code")
                    {
                    }
                    column(Customer__VAT_Registration_No__;"VAT Registration No.")
                    {
                    }
                    column(CustomersCaption;CustomersCaptionLbl)
                    {
                    }
                    column(Customer__No__Caption;FieldCaption("No."))
                    {
                    }
                    column(Customer_NameCaption;FieldCaption(Name))
                    {
                    }
                    column(Customer__Country_Region_Code_Caption;FieldCaption("Country/Region Code"))
                    {
                    }
                    column(Customer__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CheckFormat("VAT Registration No.","Country/Region Code");
                    end;
                }
                dataitem(Vendor;Vendor)
                {
                    DataItemTableView = sorting("No.") where("VAT Registration No."=filter(<>''));
                    column(ReportForNavId_3182; 3182)
                    {
                    }
                    column(Vendor__No__;"No.")
                    {
                    }
                    column(Vendor_Name;Name)
                    {
                    }
                    column(Vendor__Country_Region_Code_;"Country/Region Code")
                    {
                    }
                    column(Vendor__VAT_Registration_No__;"VAT Registration No.")
                    {
                    }
                    column(VendorsCaption;VendorsCaptionLbl)
                    {
                    }
                    column(Vendor__No__Caption;FieldCaption("No."))
                    {
                    }
                    column(Vendor_NameCaption;FieldCaption(Name))
                    {
                    }
                    column(Vendor__Country_Region_Code_Caption;FieldCaption("Country/Region Code"))
                    {
                    }
                    column(Vendor__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CheckFormat("VAT Registration No.","Country/Region Code");
                    end;
                }
                dataitem(Contact;Contact)
                {
                    DataItemTableView = sorting("No.") where("VAT Registration No."=filter(<>''));
                    column(ReportForNavId_6698; 6698)
                    {
                    }
                    column(Contact__No__;"No.")
                    {
                    }
                    column(Contact_Name;Name)
                    {
                    }
                    column(Contact__Country_Region_Code_;"Country/Region Code")
                    {
                    }
                    column(Contact__VAT_Registration_No__;"VAT Registration No.")
                    {
                    }
                    column(Contact__No__Caption;FieldCaption("No."))
                    {
                    }
                    column(Contact_NameCaption;FieldCaption(Name))
                    {
                    }
                    column(Contact__Country_Region_Code_Caption;FieldCaption("Country/Region Code"))
                    {
                    }
                    column(Contact__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
                    {
                    }
                    column(ContactsCaption;ContactsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CheckFormat("VAT Registration No.","Country/Region Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if not FormatCheck
                    then
                      CurrReport.Break;
                end;
            }
            dataitem(Integer3;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_7913; 7913)
                {
                }
                column(DuplicatesCaption;DuplicatesCaptionLbl)
                {
                }
                dataitem(Customer2;Customer)
                {
                    DataItemTableView = sorting("No.") where("VAT Registration No."=filter(<>''));
                    PrintOnlyIfDetail = true;
                    column(ReportForNavId_1159; 1159)
                    {
                    }
                    column(Customer2__No__;"No.")
                    {
                    }
                    column(Customer2_Name;Name)
                    {
                    }
                    column(Customer2__Country_Region_Code_;"Country/Region Code")
                    {
                    }
                    column(Customer2__VAT_Registration_No__;"VAT Registration No.")
                    {
                    }
                    column(VAT_Registration_No_Caption;VAT_Registration_No_CaptionLbl)
                    {
                    }
                    column(Customer2__Country_Region_Code_Caption;FieldCaption("Country/Region Code"))
                    {
                    }
                    column(NameCaption;NameCaptionLbl)
                    {
                    }
                    column(No_Caption;No_CaptionLbl)
                    {
                    }
                    column(CustomersCaption_Control50;CustomersCaption_Control50Lbl)
                    {
                    }
                    dataitem(Customer3;Customer)
                    {
                        DataItemLink = "VAT Registration No."=field("VAT Registration No.");
                        DataItemTableView = sorting("VAT Registration No.") where("VAT Registration No."=filter(<>''));
                        column(ReportForNavId_6068; 6068)
                        {
                        }
                        column(Customer3__No__;"No.")
                        {
                        }
                        column(Customer3_Name;Name)
                        {
                        }
                        column(Customer3__Country_Region_Code_;"Country/Region Code")
                        {
                        }
                        column(Customer3__VAT_Registration_No__;"VAT Registration No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Customer2."No." = "No." then
                              CurrReport.Skip;
                            if Customer2."No." > "No." then
                              CurrReport.Break;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        CopyFilters(Customer);
                    end;
                }
                dataitem(Vendor2;Vendor)
                {
                    DataItemTableView = sorting("No.") where("VAT Registration No."=filter(<>''));
                    PrintOnlyIfDetail = true;
                    column(ReportForNavId_9818; 9818)
                    {
                    }
                    column(Vendor2__No__;"No.")
                    {
                    }
                    column(Vendor2_Name;Name)
                    {
                    }
                    column(Vendor2__Country_Region_Code_;"Country/Region Code")
                    {
                    }
                    column(Vendor2__VAT_Registration_No__;"VAT Registration No.")
                    {
                    }
                    column(VendorsCaption_Control51;VendorsCaption_Control51Lbl)
                    {
                    }
                    column(Vendor2__No__Caption;FieldCaption("No."))
                    {
                    }
                    column(Vendor2_NameCaption;FieldCaption(Name))
                    {
                    }
                    column(Vendor2__Country_Region_Code_Caption;FieldCaption("Country/Region Code"))
                    {
                    }
                    column(Vendor2__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
                    {
                    }
                    dataitem(Vendor3;Vendor)
                    {
                        DataItemLink = "VAT Registration No."=field("VAT Registration No.");
                        DataItemTableView = sorting("VAT Registration No.") where("VAT Registration No."=filter(<>''));
                        column(ReportForNavId_5835; 5835)
                        {
                        }
                        column(Vendor3__No__;"No.")
                        {
                        }
                        column(Vendor3_Name;Name)
                        {
                        }
                        column(Vendor3__Country_Region_Code_;"Country/Region Code")
                        {
                        }
                        column(Vendor3__VAT_Registration_No__;"VAT Registration No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Vendor2."No." = "No." then
                              CurrReport.Skip;
                            if Vendor2."No." > "No." then
                              CurrReport.Break;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        CopyFilters(Vendor);
                    end;
                }
                dataitem(Contact2;Contact)
                {
                    DataItemTableView = sorting("No.") where("VAT Registration No."=filter(<>''));
                    PrintOnlyIfDetail = true;
                    column(ReportForNavId_3477; 3477)
                    {
                    }
                    column(Contact2__No__;"No.")
                    {
                    }
                    column(Contact2_Name;Name)
                    {
                    }
                    column(Contact2__Country_Region_Code_;"Country/Region Code")
                    {
                    }
                    column(Contact2__VAT_Registration_No__;"VAT Registration No.")
                    {
                    }
                    column(ContactsCaption_Control68;ContactsCaption_Control68Lbl)
                    {
                    }
                    column(Contact2__No__Caption;FieldCaption("No."))
                    {
                    }
                    column(Contact2_NameCaption;FieldCaption(Name))
                    {
                    }
                    column(Contact2__Country_Region_Code_Caption;FieldCaption("Country/Region Code"))
                    {
                    }
                    column(Contact2__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
                    {
                    }
                    dataitem(Contact3;Contact)
                    {
                        DataItemLink = "VAT Registration No."=field("VAT Registration No.");
                        DataItemTableView = sorting("VAT Registration No.") where("VAT Registration No."=filter(<>''));
                        column(ReportForNavId_8386; 8386)
                        {
                        }
                        column(Contact3__No__;"No.")
                        {
                        }
                        column(Contact3_Name;Name)
                        {
                        }
                        column(Contact3__Country_Region_Code_;"Country/Region Code")
                        {
                        }
                        column(Contact3__VAT_Registration_No__;"VAT Registration No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Contact2."No." = "No." then
                              CurrReport.Skip;
                            if Contact2."No." > "No." then
                              CurrReport.Break;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        CopyFilters(Contact);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if not DuplicateCheck then
                      CurrReport.Break;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.Newpage;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FormatCheck;FormatCheck)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Format Check';
                    }
                    field(DuplicateCheck;DuplicateCheck)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Duplicate Check';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        if not FormatCheck and not DuplicateCheck then begin
          FormatCheck := true;
          DuplicateCheck := true;
        end;
    end;

    var
        FormatCheck: Boolean;
        DuplicateCheck: Boolean;
        VAT_Registration_No__CheckCaptionLbl: label 'Tax Registration No. Check';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Format_ErrorsCaptionLbl: label 'Format Errors';
        CustomersCaptionLbl: label 'Customers';
        VendorsCaptionLbl: label 'Vendors';
        ContactsCaptionLbl: label 'Contacts';
        DuplicatesCaptionLbl: label 'Duplicates';
        VAT_Registration_No_CaptionLbl: label 'Tax Registration No.';
        NameCaptionLbl: label 'Name';
        No_CaptionLbl: label 'No.';
        CustomersCaption_Control50Lbl: label 'Customers';
        VendorsCaption_Control51Lbl: label 'Vendors';
        ContactsCaption_Control68Lbl: label 'Contacts';

    local procedure CheckFormat(VATRegNo: Text[20];CountryCode: Code[10])
    var
        CompanyInfo: Record "Company Information";
        VATRegNoFormat: Record "VAT Registration No. Format";
        Check: Boolean;
    begin
        if CountryCode = '' then begin
          CompanyInfo.Get;
          VATRegNoFormat.SetRange("Country/Region Code",CompanyInfo."Country/Region Code");
        end else
          VATRegNoFormat.SetRange("Country/Region Code",CountryCode);
        VATRegNoFormat.SetFilter(Format,'<>%1','');
        if VATRegNoFormat.Find('-') then begin
          repeat
            if VATRegNoFormat.Compare(VATRegNo,VATRegNoFormat.Format) = true then
              CurrReport.Skip;
          until Check or (VATRegNoFormat.Next = 0);
        end else
          CurrReport.Skip;
    end;
}

