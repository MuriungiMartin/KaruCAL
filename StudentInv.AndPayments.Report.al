#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51747 "Student Inv. And Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Inv. And Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61515;UnknownTable61515)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Charge_code;"ACA-Charge".Code)
            {
            }
            column(Charge_Desc;"ACA-Charge".Description)
            {
            }
            column(GenDate;Today)
            {
            }
            column(pict;CompanyInfo.Picture)
            {
            }
            column(datefil;datefil)
            {
            }
            column(startDate;startDate)
            {
            }
            column(endDate;endDate)
            {
            }
            dataitem("Dimension Value";"Dimension Value")
            {
                DataItemTableView = where("Dimension Code"=filter('DEPARTMENT'));
                PrintOnlyIfDetail = true;
                column(ReportForNavId_4; 4)
                {
                }
                column(deptCode;"Dimension Value".Code)
                {
                }
                column(deptName;"Dimension Value".Name)
                {
                }
                dataitem(UnknownTable61511;UnknownTable61511)
                {
                    DataItemLink = "Department Code"=field(Code);
                    PrintOnlyIfDetail = true;
                    column(ReportForNavId_9; 9)
                    {
                    }
                    column(ProgCode;"ACA-Programme".Code)
                    {
                    }
                    column(ProgDesc;"ACA-Programme".Description)
                    {
                    }
                    dataitem(UnknownTable61532;UnknownTable61532)
                    {
                        DataItemLink = Programme=field(Code);
                        PrintOnlyIfDetail = true;
                        column(ReportForNavId_6; 6)
                        {
                        }
                        column(studNo;"ACA-Course Registration"."Student No.")
                        {
                        }
                        column(StudName;"ACA-Course Registration"."Student Name")
                        {
                        }
                        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
                        {
                            DataItemLink = "Customer No."=field("Student No.");
                            DataItemTableView = where(Amount=filter(>0),Reversed=filter(false));
                            column(ReportForNavId_7; 7)
                            {
                            }
                            column(DocNo;"Cust. Ledger Entry"."Document No.")
                            {
                            }
                            column(postDate;"Cust. Ledger Entry"."Posting Date")
                            {
                            }
                            column(Amnt;"Cust. Ledger Entry".Amount)
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                 // "Cust. Ledger Entry".reset;
                                  "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry".Description,"ACA-Charge".Description);
                                 // if "Cust. Ledger Entry".find('')
                                 if datefil<>'' then
                                 "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Date Filter",'%1..%2',startDate,endDate);
                            end;
                        }

                        trigger OnPreDataItem()
                        begin
                             "ACA-Course Registration".SetFilter("ACA-Course Registration".Semester,'=%1',sems);
                        end;
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
                field(startDate;startDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'From Date';
                }
                field(EndDate;endDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'To Date';
                }
                field(sems;sems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                    TableRelation = "ACA-Semesters".Code;
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
           if compInf.Get() then begin
            if compInf."Last Used date Filter (Inv. 1)"<>0D then startDate:=compInf."Last Used date Filter (Inv. 1)";
            if compInf."Last Used date Filter (Inv. 2)"<>0D then endDate:=compInf."Last Used date Filter (Inv. 2)";
            if compInf."Last Semester Filter"<>'' then sems:=compInf."Last Semester Filter";
           end;
    end;

    trigger OnPostReport()
    begin
           if compInf.Get() then begin
            if startDate<>0D then compInf."Last Used date Filter (Inv. 1)" :=startDate;
            if endDate<>0D then  compInf."Last Used date Filter (Inv. 2)":=endDate;
            if sems<>'' then compInf."Last Semester Filter":=sems;
            compInf.Modify;
           end;
    end;

    trigger OnPreReport()
    begin
        if ((startDate=0D) and (endDate=0D)) then Error('Specify the start and/or end date');
        Clear(datefil);
        if ((startDate=0D) and (endDate<>0D)) then datefil:='..'+Format(endDate)
        else if ((startDate<>0D) and (endDate=0D)) then datefil:=Format(startDate)+'..'
        else if ((startDate<>0D) and (endDate<>0D)) then datefil:=Format(startDate)+'..'+Format(endDate);

        if (sems='') then Error('Specify the semester.');
        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        header1: Text;
        startDate: Date;
        endDate: Date;
        datefil: Text[120];
        compInf: Record "Company Information";
        CompanyInfo: Record "Company Information";
        acadyear: Code[30];
        sems: Code[30];
}

