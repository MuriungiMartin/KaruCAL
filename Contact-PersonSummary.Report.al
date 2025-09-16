#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5053 "Contact - Person Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contact - Person Summary.rdlc';
    Caption = 'Contact - Person Summary';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Contact;Contact)
        {
            DataItemTableView = sorting("No.") where(Type=const(Person));
            RequestFilterFields = "No.","Salesperson Code","Post Code","Country/Region Code";
            column(ReportForNavId_6698; 6698)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Contact_TABLECAPTION__________ContactFilter;TableCaption + ': ' + ContactFilter)
            {
            }
            column(ContactFilter;ContactFilter)
            {
            }
            column(Contact__Company_No__;"Company No.")
            {
            }
            column(ContAddr_1_;ContAddr[1])
            {
            }
            column(ContAddr_2_;ContAddr[2])
            {
            }
            column(ContAddr_3_;ContAddr[3])
            {
            }
            column(ContAddr_4_;ContAddr[4])
            {
            }
            column(ContAddr_5_;ContAddr[5])
            {
            }
            column(ContAddr_6_;ContAddr[6])
            {
            }
            column(ContAddr_7_;ContAddr[7])
            {
            }
            column(ContAddr_8_;ContAddr[8])
            {
            }
            column(Contact__Phone_No__;"Phone No.")
            {
            }
            column(Contact__E_Mail_;"E-Mail")
            {
            }
            column(NoOfRecord;NoOfRecord)
            {
            }
            column(Contact___Person_SummaryCaption;Contact___Person_SummaryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Contact__Company_No__Caption;FieldCaption("Company No."))
            {
            }
            column(Contact__Phone_No__Caption;FieldCaption("Phone No."))
            {
            }
            column(Contact__E_Mail_Caption;FieldCaption("E-Mail"))
            {
            }
            dataitem("To-do";"To-do")
            {
                DataItemLink = "Contact Company No."=field("Company No."),"Contact No."=field("No.");
                DataItemTableView = sorting("Contact Company No.","Contact No.",Closed,Date) where("System To-do Type"=const("Contact Attendee"));
                RequestFilterFields = Closed,Date,Type;
                column(ReportForNavId_6499; 6499)
                {
                }
                column(To_do_Description;Description)
                {
                }
                column(To_do_Date;Format(Date))
                {
                }
                column(To_do_Status;Status)
                {
                }
                column(To_do_Priority;Priority)
                {
                }
                column(To_do_Type;Type)
                {
                }
                column(To_do__Team_Code_;"Team Code")
                {
                }
                column(To_do__Salesperson_Code_;"Salesperson Code")
                {
                }
                column(To_do__Contact_No__;"Contact No.")
                {
                }
                column(To_do__No__;"No.")
                {
                }
                column(Format_Closed;Format(Closed))
                {
                }
                column(To_dosCaption;To_dosCaptionLbl)
                {
                }
                column(DateCaption;DateCaptionLbl)
                {
                }
                column(DescriptionCaption;DescriptionCaptionLbl)
                {
                }
                column(TypeCaption;TypeCaptionLbl)
                {
                }
                column(StatusCaption;StatusCaptionLbl)
                {
                }
                column(PriorityCaption;PriorityCaptionLbl)
                {
                }
                column(Team_CodeCaption;Team_CodeCaptionLbl)
                {
                }
                column(Salesperson_CodeCaption;Salesperson_CodeCaptionLbl)
                {
                }
                column(ClosedCaption;ClosedCaptionLbl)
                {
                }
                column(To_do__Contact_No__Caption;FieldCaption("Contact No."))
                {
                }
                column(To_do__No__Caption;FieldCaption("No."))
                {
                }
            }
            dataitem("<Interaction Log Entry>";"Interaction Log Entry")
            {
                DataItemLink = "Contact Company No."=field("Company No."),"Contact No."=field("No.");
                DataItemTableView = sorting("Contact Company No.","Contact No.",Date) where(Postponed=const(false));
                RequestFilterFields = Date,"Interaction Group Code","Interaction Template Code","Information Flow","Initiated By";
                column(ReportForNavId_7926; 7926)
                {
                }
                column(Interaction_Log_Entry__Description;Description)
                {
                }
                column(Interaction_Log_Entry___Information_Flow_;"Information Flow")
                {
                }
                column(Interaction_Log_Entry___Initiated_By_;"Initiated By")
                {
                }
                column(Interaction_Log_Entry__Date;Format(Date))
                {
                }
                column(Interaction_Log_Entry___Contact_No__;"Contact No.")
                {
                }
                column(Interaction_Log_Entry___To_do_No__;"To-do No.")
                {
                }
                column(Interaction_Log_Entry___Entry_No__;"Entry No.")
                {
                }
                column(Interaction_Log_Entry___Salesperson_Code_;"Salesperson Code")
                {
                }
                column(InteractionsCaption;InteractionsCaptionLbl)
                {
                }
                column(Interaction_Log_Entry__DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Interaction_Log_Entry___Information_Flow_Caption;FieldCaption("Information Flow"))
                {
                }
                column(Interaction_Log_Entry___Initiated_By_Caption;FieldCaption("Initiated By"))
                {
                }
                column(DateCaption_Control88;DateCaption_Control88Lbl)
                {
                }
                column(Interaction_Log_Entry___Contact_No__Caption;FieldCaption("Contact No."))
                {
                }
                column(Interaction_Log_Entry___To_do_No__Caption;FieldCaption("To-do No."))
                {
                }
                column(Interaction_Log_Entry___Entry_No__Caption;FieldCaption("Entry No."))
                {
                }
                column(Interaction_Log_Entry___Salesperson_Code_Caption;FieldCaption("Salesperson Code"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.ContactAddr(ContAddr,Contact);
                NoOfRecord := NoOfRecord + 1;
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

    trigger OnPreReport()
    begin
        ContactFilter := Contact.GetFilters;
        NoOfRecord := 0;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        ContactFilter: Text;
        ContAddr: array [8] of Text[50];
        NoOfRecord: Integer;
        Contact___Person_SummaryCaptionLbl: label 'Contact - Person Summary';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        To_dosCaptionLbl: label 'To-dos';
        DateCaptionLbl: label 'Date';
        DescriptionCaptionLbl: label 'Description';
        TypeCaptionLbl: label 'Type';
        StatusCaptionLbl: label 'Status';
        PriorityCaptionLbl: label 'Priority';
        Team_CodeCaptionLbl: label 'Team Code';
        Salesperson_CodeCaptionLbl: label 'Salesperson Code';
        ClosedCaptionLbl: label 'Closed';
        InteractionsCaptionLbl: label 'Interactions';
        DateCaption_Control88Lbl: label 'Date';
}

