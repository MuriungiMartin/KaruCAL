#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5223 "Human Resource Comment List"
{
    Caption = 'Comment List';
    DataCaptionExpression = Caption(Rec);
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Human Resource Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number for the employee.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the comment itself.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the comment.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        EmployeeQualification: Record "Employee Qualification";
        EmployeeRelative: Record "Employee Relative";
        MiscArticleInfo: Record "Misc. Article Information";
        ConfidentialInfo: Record "Confidential Information";
        Text000: label 'untitled', Comment='it is a caption for empty page';

    local procedure Caption(HRCommentLine: Record "Human Resource Comment Line"): Text[110]
    begin
        case HRCommentLine."Table Name" of
          HRCommentLine."table name"::"Employee Absence":
            if EmployeeAbsence.Get(HRCommentLine."Table Line No.") then begin
              Employee.Get(EmployeeAbsence."Employee No.");
              exit(
                Employee."No." + ' ' + Employee.FullName + ' ' +
                EmployeeAbsence."Cause of Absence Code" + ' ' +
                Format(EmployeeAbsence."From Date"));
            end;
          HRCommentLine."table name"::Employee:
            if Employee.Get(HRCommentLine."No.") then
              exit(HRCommentLine."No." + ' ' + Employee.FullName);
          HRCommentLine."table name"::"Alternative Address":
            if Employee.Get(HRCommentLine."No.") then
              exit(
                HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                HRCommentLine."Alternative Address Code");
          HRCommentLine."table name"::"Employee Qualification":
            if EmployeeQualification.Get(HRCommentLine."No.",HRCommentLine."Table Line No.") and
               Employee.Get(HRCommentLine."No.")
            then
              exit(
                HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                EmployeeQualification."Qualification Code");
          HRCommentLine."table name"::"Employee Relative":
            if EmployeeRelative.Get(HRCommentLine."No.",HRCommentLine."Table Line No.") and
               Employee.Get(HRCommentLine."No.")
            then
              exit(
                HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                EmployeeRelative."Relative Code");
          HRCommentLine."table name"::"Misc. Article Information":
            if MiscArticleInfo.Get(
                 HRCommentLine."No.",HRCommentLine."Alternative Address Code",HRCommentLine."Table Line No.") and
               Employee.Get(HRCommentLine."No.")
            then
              exit(
                HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                MiscArticleInfo."Misc. Article Code");
          HRCommentLine."table name"::"Confidential Information":
            if ConfidentialInfo.Get(HRCommentLine."No.",HRCommentLine."Table Line No.") and
               Employee.Get(HRCommentLine."No.")
            then
              exit(
                HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                ConfidentialInfo."Confidential Code");
        end;
        exit(Text000);
    end;
}

