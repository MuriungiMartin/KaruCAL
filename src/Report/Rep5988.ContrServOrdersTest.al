#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5988 "Contr. Serv. Orders - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contr. Serv. Orders - Test.rdlc';
    Caption = 'Contr. Serv. Orders - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = where("Contract Type"=const(Contract),"Change Status"=const(Locked),Status=const(Signed));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Contract No.";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(StartDate;Format(StartDate))
            {
            }
            column(EndDate;Format(EndDate))
            {
            }
            column(Service_Contract_Header__TABLECAPTION__________ServContractFilters;TableCaption + ': ' + ServContractFilters)
            {
            }
            column(ShowServContractFilters;ServContractFilters)
            {
            }
            column(ShowFullBody;ShowFullBody)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Contract_Service_Orders___TestCaption;Contract_Service_Orders___TestCaptionLbl)
            {
            }
            column(StartDateCaption;StartDateCaptionLbl)
            {
            }
            column(EndDateCaption;EndDateCaptionLbl)
            {
            }
            column(Service_Contract_Line__Next_Planned_Service_Date_Caption;Service_Contract_Line__Next_Planned_Service_Date_CaptionLbl)
            {
            }
            column(Service_Contract_Line__Last_Service_Date_Caption;Service_Contract_Line__Last_Service_Date_CaptionLbl)
            {
            }
            column(Service_Contract_Line__Last_Planned_Service_Date_Caption;Service_Contract_Line__Last_Planned_Service_Date_CaptionLbl)
            {
            }
            column(Service_Contract_Line_DescriptionCaption;"Service Contract Line".FieldCaption(Description))
            {
            }
            column(Service_Contract_Line__Serial_No__Caption;"Service Contract Line".FieldCaption("Serial No."))
            {
            }
            column(Service_Contract_Line__Contract_No__Caption;"Service Contract Line".FieldCaption("Contract No."))
            {
            }
            column(Customer_No_Caption;Customer_No_CaptionLbl)
            {
            }
            column(Customer_NameCaption;Customer_NameCaptionLbl)
            {
            }
            dataitem("Service Contract Line";"Service Contract Line")
            {
                DataItemLink = "Contract Type"=field("Contract Type"),"Contract No."=field("Contract No.");
                DataItemTableView = sorting("Contract Type","Contract No.","Line No.") order(ascending) where("Service Period"=filter(<>''));
                column(ReportForNavId_6062; 6062)
                {
                }
                column(Service_Contract_Line__Serial_No__;"Serial No.")
                {
                }
                column(Service_Contract_Line__Last_Planned_Service_Date_;Format("Last Planned Service Date"))
                {
                }
                column(Service_Contract_Line__Next_Planned_Service_Date_;Format("Next Planned Service Date"))
                {
                }
                column(Service_Contract_Line__Last_Service_Date_;Format("Last Service Date"))
                {
                }
                column(Service_Contract_Line_Description;Description)
                {
                }
                column(Service_Contract_Line__Contract_No__;"Contract No.")
                {
                }
                column(Cust__No__;Cust."No.")
                {
                }
                column(Cust_Name;Cust.Name)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Contract Expiration Date" <> 0D then begin
                      if "Contract Expiration Date" <= "Next Planned Service Date" then
                        CurrReport.Skip;
                    end else
                      if ("Service Contract Header"."Expiration Date" <> 0D) and
                         ("Service Contract Header"."Expiration Date" <= "Next Planned Service Date")
                      then
                        CurrReport.Skip;

                    Cust.Get("Service Contract Header"."Bill-to Customer No.");
                    if Cust.Blocked = Cust.Blocked::All then
                      CurrReport.Skip;

                    ServHeader.SetCurrentkey("Contract No.",Status,"Posting Date");
                    ServHeader.SetRange("Contract No.","Contract No.");
                    ServHeader.SetRange(Status,ServHeader.Status::Pending);

                    if ServHeader.FindFirst then begin
                      ServItemLine.SetCurrentkey("Document Type","Document No.","Service Item No.");
                      ServItemLine.SetRange("Document Type",ServHeader."Document Type");
                      ServItemLine.SetRange("Document No.",ServHeader."No.");
                      ServItemLine.SetRange("Contract No.","Contract No.");
                      ServItemLine.SetRange("Contract Line No.","Line No.");
                      if ServItemLine.FindFirst then
                        CurrReport.Skip;
                    end;

                    if LastContractNo <> "Contract No." then begin
                      LastContractNo := "Contract No.";
                      ShowFullBody := true;
                    end else
                      ShowFullBody := false;
                end;

                trigger OnPreDataItem()
                begin
                    if EndDate = 0D then
                      Error(Text000);
                    if EndDate < StartDate then
                      Error(Text001);

                    if StartDate <> 0D then begin
                      if EndDate - StartDate + 1 > ServMgtSetup."Contract Serv. Ord.  Max. Days" then
                        Error(
                          Text002,
                          ServMgtSetup.TableCaption);
                    end;

                    if GetFilter("Contract No.") = '' then
                      SetFilter("Contract No.",'<>%1','');
                    SetRange("Next Planned Service Date",StartDate,EndDate);
                end;
            }
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
                    field(StartDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate;EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            if EndDate < StartDate then
                              Error(Text001);
                        end;
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
        ServMgtSetup.Get;
        if StartDate = 0D then
          if ServMgtSetup."Last Contract Service Date" <> 0D then
            StartDate := ServMgtSetup."Last Contract Service Date" + 1;
    end;

    trigger OnPreReport()
    begin
        ServContractFilters := "Service Contract Header".GetFilters;
    end;

    var
        Text000: label 'You must fill in the ending date field.';
        Text001: label 'Starting Date is greater than Ending Date.';
        Text002: label 'The date range you have entered is a longer period than is allowed in the %1 table.';
        ServMgtSetup: Record "Service Mgt. Setup";
        ServHeader: Record "Service Header";
        Cust: Record Customer;
        ServItemLine: Record "Service Item Line";
        LastContractNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        ServContractFilters: Text;
        ShowFullBody: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Contract_Service_Orders___TestCaptionLbl: label 'Contract Service Orders - Test';
        StartDateCaptionLbl: label 'Starting Date';
        EndDateCaptionLbl: label 'Ending Date';
        Service_Contract_Line__Next_Planned_Service_Date_CaptionLbl: label 'Next Planned Service Date';
        Service_Contract_Line__Last_Service_Date_CaptionLbl: label 'Last Service Date';
        Service_Contract_Line__Last_Planned_Service_Date_CaptionLbl: label 'Last Planned Service Date';
        Customer_No_CaptionLbl: label 'Customer No.';
        Customer_NameCaptionLbl: label 'Customer Name';


    procedure InitVariables(LocalStartDate: Date;LocalEndDate: Date)
    begin
        StartDate := LocalStartDate;
        EndDate := LocalEndDate;
    end;
}

