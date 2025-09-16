#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66662 "HRM-Employee Status Log"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Employee Status Log.rdlc';

    dataset
    {
        dataitem(HRM_Status;UnknownTable66700)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(RefNo;HRM_Status."Record No.")
            {
            }
            column(EmpNo;HRM_Status."Employee No.")
            {
            }
            column(EmpName;HRM_Status."Employee Name")
            {
            }
            column(RefDates;HRM_Status."Reference Date")
            {
            }
            column(UserID;HRM_Status."User ID")
            {
            }
            column(OldVal;HRM_Status."Old Value")
            {
            }
            column(NewVal;HRM_Status."New Value")
            {
            }
            column(TransType;HRM_Status."Transaction Type")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(Phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(Mails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(WhatChanged;HRM_Status."Field/Value Changed")
            {
            }
            column(Pics;CompanyInformation.Picture)
            {
            }
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
        CompanyInformation: Record "Company Information";
}

