#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51457 "Standard Leave Balance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Standard Leave Balance Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_3372; 3372)
            {
            }
            column(compName;CompanyInformation.Name)
            {
            }
            column(addresses;CompanyInformation.Address+','+CompanyInformation."Address 2")
            {
            }
            column(phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(emails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(pics;CompanyInformation.Picture)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Names;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(Standard_Leave_Balance_ReportCaption;Standard_Leave_Balance_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            dataitem(UnknownTable61659;UnknownTable61659)
            {
                DataItemLink = "Employee No"=field("No.");
                column(ReportForNavId_1; 1)
                {
                }
                column(entryno;"HRM-Leave Ledger"."Entry No.")
                {
                }
                column(DocNo;"HRM-Leave Ledger"."Document No")
                {
                }
                column(LeaveType;"HRM-Leave Ledger"."Leave Type")
                {
                }
                column(TransDate;"HRM-Leave Ledger"."Transaction Date")
                {
                }
                column(Transtype;"HRM-Leave Ledger"."Transaction Type")
                {
                }
                column(NoOfDays;"HRM-Leave Ledger"."No. of Days")
                {
                }
                column(TransDesc;"HRM-Leave Ledger"."Transaction Description")
                {
                }
                column(LeavePer;"HRM-Leave Ledger"."Leave Period")
                {
                }
                column(EntryType;"HRM-Leave Ledger"."Entry Type")
                {
                }
                column(CreatedBy;"HRM-Leave Ledger"."Created By")
                {
                }
                column(ReversedBy;"HRM-Leave Ledger"."Reversed By")
                {
                }
                column(relName;RelieverName)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RelieverName:='';
                    HRMLeaveRequisition.Reset;
                    HRMLeaveRequisition.SetRange("No.","HRM-Leave Ledger"."Document No");
                    if HRMLeaveRequisition.Find('-') then begin
                      RelieverName:=HRMLeaveRequisition."Reliever Name";
                      end;
                end;
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Standard_Leave_Balance_ReportCaptionLbl: label 'Standard Leave Balance Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        CompanyInformation: Record "Company Information";
        HRMLeaveRequisition: Record UnknownRecord61125;
        RelieverName: Text;
}

