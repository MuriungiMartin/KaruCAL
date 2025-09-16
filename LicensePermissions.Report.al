#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10313 "License Permissions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/License Permissions.rdlc';
    Caption = 'License Permissions';

    dataset
    {
        dataitem("Permission Range";"Permission Range")
        {
            DataItemTableView = sorting("Object Type",Index);
            RequestFilterFields = "Object Type";
            column(ReportForNavId_8434; 8434)
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
            column(Permission_Range__Object_Type_;"Object Type")
            {
            }
            column(Permission_Range_From;From)
            {
            }
            column(Permission_Range__To_;"To")
            {
            }
            column(Permission_Range__Read_Permission_;"Read Permission")
            {
            }
            column(Permission_Range__Insert_Permission_;"Insert Permission")
            {
            }
            column(Permission_Range__Delete_Permission_;"Delete Permission")
            {
            }
            column(Permission_Range__Execute_Permission_;"Execute Permission")
            {
            }
            column(Permission_Range__Modify_Permission_;"Modify Permission")
            {
            }
            column(Description;Description)
            {
            }
            column(Permission_Range_Index;Index)
            {
            }
            column(License_PermissionsCaption;License_PermissionsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Permission_Range__Object_Type_Caption;FieldCaption("Object Type"))
            {
            }
            column(Permission_Range_FromCaption;FieldCaption(From))
            {
            }
            column(Permission_Range__To_Caption;FieldCaption("To"))
            {
            }
            column(Permission_Range__Read_Permission_Caption;FieldCaption("Read Permission"))
            {
            }
            column(Permission_Range__Insert_Permission_Caption;FieldCaption("Insert Permission"))
            {
            }
            column(Permission_Range__Delete_Permission_Caption;FieldCaption("Delete Permission"))
            {
            }
            column(Permission_Range__Execute_Permission_Caption;FieldCaption("Execute Permission"))
            {
            }
            column(Permission_Range__Modify_Permission_Caption;FieldCaption("Modify Permission"))
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Description := '';
                if "Object Type" = "object type"::System then begin
                  if SysObject.Get("Object Type",From) then
                    Description := SysObject."Object Name";
                end;
            end;
        }
        dataitem("License Information";"License Information")
        {
            DataItemTableView = sorting("Line No.");
            column(ReportForNavId_8604; 8604)
            {
            }
            column(USERID_Control12;UserId)
            {
            }
            column(CurrReport_PAGENO_Control13;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4__Control19;Format(Today,0,4))
            {
            }
            column(COMPANYNAME_Control25;COMPANYNAME)
            {
            }
            column(SkipHeader;SkipHeader)
            {
            }
            column(License_Information_Text;Text)
            {
            }
            column(License_Information_Line_No_;"Line No.")
            {
            }
            column(CurrReport_PAGENO_Control13Caption;CurrReport_PAGENO_Control13CaptionLbl)
            {
            }
            column(License_PermissionsCaption_Control22;License_PermissionsCaption_Control22Lbl)
            {
            }

            trigger OnPreDataItem()
            begin
                SkipHeader := true;
                CurrReport.Newpage;
                SkipHeader := false;
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

    var
        SysObject: Record "System Object";
        Description: Text[50];
        SkipHeader: Boolean;
        License_PermissionsCaptionLbl: label 'License Permissions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DescriptionCaptionLbl: label 'Description';
        CurrReport_PAGENO_Control13CaptionLbl: label 'Page';
        License_PermissionsCaption_Control22Lbl: label 'License Permissions';
}

