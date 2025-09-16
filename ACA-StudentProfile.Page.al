#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68158 "ACA-Student Profile"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action("Student Login")
            {
                ApplicationArea = Basic;
                Image = Lock;
                InFooterBar = true;
                RunObject = Page "ACA-Student Password";
            }
            separator(Action7)
            {
            }
            separator(Action8)
            {
            }
            action("Staff Login")
            {
                ApplicationArea = Basic;
                Image = Lock;
                RunObject = Page "ACA-Staff Password";
            }
        }
        area(creation)
        {
            separator(Action9)
            {
            }
            action("Application Form")
            {
                ApplicationArea = Basic;
                Image = New;
                RunObject = Page "ACA-Application Form Header";
            }
        }
    }
}

