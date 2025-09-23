CREATE TABLE [dbo].[pl_user_grp_prvlg](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[grp_id] [int] NULL,
	[func_id] [int] NULL,
	[is_view] [bit] NULL,
	[is_append] [bit] NULL,
	[is_edit] [bit] NULL,
	[is_delete] [bit] NULL,
 CONSTRAINT [PK_pl_user_grp_prvlg] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

insert into pl_user_grp_prvlg(grp_id, func_id,is_view,is_append,is_edit,is_delete)
select g.grp_id, f.id, g.is_view, g.is_append, g.is_edit, g.is_delete
from user_grp_prvlg g join functions f on g.func_id = f.code


go 

exec sp_rename 'dbo.user_grp_prvlg', 'user_grp_prvlg_ex'

go 

exec sp_rename 'dbo.pl_user_grp_prvlg', 'user_grp_prvlg'

