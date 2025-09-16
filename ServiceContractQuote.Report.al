#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5972 "Service Contract Quote"
{
    // CurrReport.SHOWOUTPUT := FALSE;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Contract Quote.rdlc';

    Caption = 'Service Contract Quote';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            CalcFields = "Bill-to Name";
            DataItemTableView = sorting("Contract Type","Contract No.") where("Contract Type"=filter(Quote));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Contract No.","Customer No.";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(ContType_ServContractHdr;"Contract Type")
            {
            }
            column(ContNo_ServContractHdr;"Contract No.")
            {
                IncludeCaption = true;
            }
            dataitem(CopyLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5701; 5701)
                {
                }
                column(OutputNo;OutputNo)
                {
                }
                dataitem(PageLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_6455; 6455)
                    {
                    }
                    column(CompanyInfoPicture;CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(AnnualAmt_ServContractHdr;"Service Contract Header"."Annual Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(InvPeriod_ServContractHdr;"Service Contract Header"."Invoice Period")
                    {
                        IncludeCaption = true;
                    }
                    column(StartDt_ServContractHdr;Format("Service Contract Header"."Starting Date"))
                    {
                    }
                    column(NextInvDate_ServContractHdr;Format("Service Contract Header"."Next Invoice Date"))
                    {
                    }
                    column(AcceptBef_ServContractHdr;"Service Contract Header"."Accept Before")
                    {
                        IncludeCaption = true;
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(CurrReportPageNo;StrSubstNo(Text002,Format(CurrReport.PageNo)))
                    {
                    }
                    column(ServContractQuote;StrSubstNo(Text001,CopyText))
                    {
                    }
                    column(CustAddr6;CustAddr[6])
                    {
                    }
                    column(CustAddr5;CustAddr[5])
                    {
                    }
                    column(CustAddr4;CustAddr[4])
                    {
                    }
                    column(CustAddr2;CustAddr[2])
                    {
                    }
                    column(CustAddr3;CustAddr[3])
                    {
                    }
                    column(CustAddr1;CustAddr[1])
                    {
                    }
                    column(BilltoNam_ServContractHdr;"Service Contract Header"."Bill-to Name")
                    {
                    }
                    column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoFaxNo;CompanyInfo."Fax No.")
                    {
                    }
                    column(EMail_ServContractHdr;"Service Contract Header"."E-Mail")
                    {
                    }
                    column(PhoneNo_ServContractHdr;"Service Contract Header"."Phone No.")
                    {
                    }
                    column(PageCaption;StrSubstNo(Text002,''))
                    {
                    }
                    column(ServContractStartDtCptn;ServContractStartDtCptnLbl)
                    {
                    }
                    column(ServContractNextInvDtCptn;ServContractNextInvDtCptnLbl)
                    {
                    }
                    column(InvoicetoCaption;InvoicetoCaptionLbl)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoFaxNoCaption;CompanyInfoFaxNoCaptionLbl)
                    {
                    }
                    column(ServContractPhoneNoCptn;ServContractPhoneNoCptnLbl)
                    {
                    }
                    column(ServContractEMailCaption;ServContractEMailCaptionLbl)
                    {
                    }
                    dataitem("Contract/Service Discount";"Contract/Service Discount")
                    {
                        DataItemLink = "Contract Type"=field("Contract Type"),"Contract No."=field("Contract No.");
                        DataItemLinkReference = "Service Contract Header";
                        DataItemTableView = sorting("Contract Type","Contract No.",Type,"No.","Starting Date");
                        column(ReportForNavId_7607; 7607)
                        {
                        }
                        column(Type_ContractServDisc;Type)
                        {
                            IncludeCaption = true;
                        }
                        column(No_ContractServDisc;"No.")
                        {
                            IncludeCaption = true;
                        }
                        column(StartDt_ContractServDisc;Format("Starting Date"))
                        {
                        }
                        column(Discount_ContractServDisc;"Discount %")
                        {
                            IncludeCaption = true;
                        }
                        column(ContNo_ContractServDisc;"Contract No.")
                        {
                        }
                        column(ContractServDiscStrtDtCptn;ContractServDiscStrtDtCptnLbl)
                        {
                        }
                        column(ServiceDiscountsCaption;ServiceDiscountsCaptionLbl)
                        {
                        }
                    }
                    dataitem("Service Contract Line";"Service Contract Line")
                    {
                        DataItemLink = "Contract Type"=field("Contract Type"),"Contract No."=field("Contract No.");
                        DataItemLinkReference = "Service Contract Header";
                        DataItemTableView = sorting("Contract Type","Contract No.","Line No.");
                        column(ReportForNavId_6062; 6062)
                        {
                        }
                        column(ServItemNo_ServContractLine;"Service Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_ServContractLine;Description)
                        {
                            IncludeCaption = true;
                        }
                        column(ItemNo_ServContractLine;"Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(SlNo_ServContractLine;"Serial No.")
                        {
                            IncludeCaption = true;
                        }
                        column(ServicePeriod_ServContractLine;"Service Period")
                        {
                            IncludeCaption = true;
                        }
                        column(UOMCode_ServContractLine;"Unit of Measure Code")
                        {
                            IncludeCaption = true;
                        }
                        column(RespTime_ServContractLine;"Response Time (Hours)")
                        {
                            IncludeCaption = true;
                        }
                        column(LineValue_ServContractLine;"Line Value")
                        {
                            IncludeCaption = true;
                        }
                        column(ContType_ServContractLine;"Contract Type")
                        {
                        }
                        column(ContNo_ServContractLine;"Contract No.")
                        {
                        }
                        column(LineNo_ServContractLine;"Line No.")
                        {
                        }
                        dataitem("Service Comment Line";"Service Comment Line")
                        {
                            DataItemLink = "Table Subtype"=field("Contract Type"),"Table Line No."=field("Line No."),"No."=field("Contract No.");
                            DataItemTableView = sorting("Table Name","Table Subtype","No.",Type,"Table Line No.","Line No.") order(ascending) where("Table Name"=filter("Service Contract"));
                            column(ReportForNavId_9771; 9771)
                            {
                            }
                            column(ShowComments;ShowComments)
                            {
                            }
                            column(Date_ServiceCommentLine;Format(Date))
                            {
                            }
                            column(Comment_ServCommentLine;Comment)
                            {
                                IncludeCaption = true;
                            }
                            column(TblSbtype_ServiceCommLine;"Table Subtype")
                            {
                            }
                            column(Type_ServiceCommentLine;Type)
                            {
                            }
                            column(LineNo_ServiceCommentLine;"Line No.")
                            {
                            }
                            column(ServCommentLineDtCaption;ServCommentLineDtCaptionLbl)
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                if not ShowComments then
                                  CurrReport.Break;
                            end;
                        }
                    }
                }
                dataitem(Shipto;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_6218; 6218)
                    {
                    }
                    column(ShipToAddr6;ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr5;ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr4;ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr3;ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr2;ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr1;ShipToAddr[1])
                    {
                    }
                    column(ShipToCode;"Service Contract Header"."Ship-to Code")
                    {
                    }
                    column(ShiptoAddressCaption;ShiptoAddressCaptionLbl)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not ShowShippingAddr then
                          CurrReport.Break;
                    end;
                }
                dataitem(ServCommentLine2;"Service Comment Line")
                {
                    DataItemLink = "No."=field("Contract No."),"Table Subtype"=field("Contract Type");
                    DataItemLinkReference = "Service Contract Header";
                    DataItemTableView = sorting("Table Name","Table Subtype","No.",Type,"Table Line No.","Line No.") order(ascending) where("Table Name"=filter("Service Contract"),"Table Line No."=filter(0));
                    column(ReportForNavId_2756; 2756)
                    {
                    }
                    column(ShowComments1;ShowComments)
                    {
                    }
                    column(Date_ServCommentLine2;Format(Date))
                    {
                    }
                    column(Comment_ServCommentLine2;Comment)
                    {
                        IncludeCaption = true;
                    }
                    column(ServCommentLine2TableSubtype;"Table Subtype")
                    {
                    }
                    column(Type_ServCommentLine2;Type)
                    {
                    }
                    column(LineNo_ServCommentLine2;"Line No.")
                    {
                    }
                    column(CommentsCaption;CommentsCaptionLbl)
                    {
                    }
                    column(ServCommentLine2DtCaption;ServCommentLine2DtCaptionLbl)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not ShowComments then
                          CurrReport.Break;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                      NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddr.GetCompanyAddr("Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
                FormatAddr.ServContractSellto(CustAddr,"Service Contract Header");
                ShowShippingAddr := "Ship-to Code" <> '' ;
                if ShowShippingAddr then
                  FormatAddr.ServContractShipto(ShipToAddr,"Service Contract Header");

                if LogInteraction then
                  if not CurrReport.Preview then begin
                    if "Contact No." <> '' then
                      SegManagement.LogDocument(
                        24,"Contract No.",0,0,Database::Contact,"Contact No.","Salesperson Code",'','','')
                    else
                      SegManagement.LogDocument(
                        24,"Contract No.",0,0,Database::Customer,"Customer No.","Salesperson Code",'','','')
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies;NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field(ShowComments;ShowComments)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Comments';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(24) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        ServiceSetup.Get;
        FormatDocument.SetLogoPosition(ServiceSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        ServiceSetup: Record "Service Mgt. Setup";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        ShowShippingAddr: Boolean;
        ShowComments: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        Text001: label 'Service Contract Quote %1';
        Text002: label 'Page %1';
        LogInteraction: Boolean;
        OutputNo: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ServContractStartDtCptnLbl: label 'Starting Date';
        ServContractNextInvDtCptnLbl: label 'Next Invoice Date';
        InvoicetoCaptionLbl: label 'Invoice to';
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoFaxNoCaptionLbl: label 'Fax No.';
        ServContractPhoneNoCptnLbl: label 'Phone No.';
        ServContractEMailCaptionLbl: label 'Email';
        ContractServDiscStrtDtCptnLbl: label 'Starting Date';
        ServiceDiscountsCaptionLbl: label 'Service Discounts';
        ServCommentLineDtCaptionLbl: label 'Date';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';
        CommentsCaptionLbl: label 'Comments';
        ServCommentLine2DtCaptionLbl: label 'Date';


    procedure InitializeRequestComment(ShowCommentsFrom: Boolean)
    begin
        ShowComments := ShowCommentsFrom;
    end;
}

