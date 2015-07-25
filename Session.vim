let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Sites/kollecto-survey-builder
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +34 app/models/user.rb
badd +27 config/secrets.yml
badd +122 ~/dotfiles/vim/.vimrc.ruby
badd +5 config/database.yml
badd +13 app/controllers/application_controller.rb
badd +4 db/migrate/20150721215149_add_stuff_to_users.rb
badd +6 config/routes.rb
badd +18 app/controllers/survey_submissions_controller.rb
badd +3 app/views/survey_submissions/start.html.haml
badd +26 app/models/ability.rb
badd +31 app/views/survey_submissions/take_survey.html.haml
badd +1 app/views/devise/registrations/new.html.haml
badd +4 db/migrate/20150721222217_create_join_table_user_taste_category.rb
badd +5 app/models/taste_category.rb
badd +2 app/controllers/registrations_controller.rb
badd +7 app/views/shared/_main_nav.html.haml
badd +32 app/assets/stylesheets/bootstrap-overrides.scss
badd +14 app/views/layouts/application.html.haml
badd +7 app/views/home/home.html.haml
badd +24 app/models/survey_submission.rb
badd +12 app/views/devise/sessions/new.html.haml
badd +19 db/schema.rb
badd +229 app/models/survey_iteration.rb
badd +1 app/controllers/survey_questions_controller.rb
badd +1 spec/models/survey_page_spec.rb
badd +10 app/models/survey_page.rb
badd +70 app/models/survey_question.rb
badd +27 app/models/concerns/survey_page_navigation.rb
badd +8 app/controllers/home_controller.rb
badd +81 config/environments/production.rb
badd +37 Gemfile
badd +22 Capfile
badd +34 config/deploy/staging.rb
badd +12 config/deploy.rb
badd +30 config/application.rb
badd +87 config/environments/staging.rb
badd +5 app/controllers/admin/base_controller.rb
badd +3 app/views/admin/base/dashboard.html.haml
badd +11 app/views/admin/base/_admin_frame.html.haml
badd +118 app/assets/stylesheets/dashboard.css
badd +12 config/initializers/assets.rb
badd +5 app/controllers/admin/users_controller.rb
badd +7 app/views/admin/users/index.html.haml
badd +10 app/views/admin/users/_table.html.haml
badd +2 app/views/admin/users/_table_row.html.haml
badd +8 app/views/admin/users/_details_cell.html.haml
badd +7 app/views/admin/users/edit.html.haml
badd +10 app/views/admin/users/show.html.haml
badd +3 app/assets/javascripts/admin/survey_iterations.coffee
badd +20 app/controllers/admin/survey_iterations_controller.rb
badd +7 app/views/admin/survey_iterations/index.html.haml
badd +9 app/views/admin/survey_iterations/_table.html.haml
badd +2 app/views/admin/survey_iterations/_table_row.html.haml
badd +23 app/views/admin/survey_iterations/_details_cell.html.haml
badd +17 app/helpers/admin/survey_iterations_helper.rb
badd +35 app/models/survey_option.rb
badd +5 app/jobs/publish_to_sg_job.rb
badd +1 config/initializers/active_job.rb
badd +1 app/views/admin/survey_iterations/new.html.haml
badd +5 app/views/admin/survey_iterations/_form.html.haml
badd +4 app/views/admin/survey_iterations/edit.html.haml
badd +3 app/assets/javascripts/shared.coffee
badd +1 app/controllers/survey_iterations_controller.rb
badd +4 app/views/admin/survey_iterations/show.html.haml
badd +5 db/migrate/20150724232443_add_sg_publishing_jid_to_survey_iterations.rb
badd +1 app/helpers/survey_iterations_helper.rb
badd +0 app/jobs/delete_from_sg_job.rb
badd +6 db/migrate/20150725002217_add_deletion_datetimes_to_survey_iterations.rb
argglobal
silent! argdel *
edit app/models/survey_iteration.rb
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd w
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd w
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd w
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe '1resize ' . ((&lines * 24 + 31) / 62)
exe 'vert 1resize ' . ((&columns * 90 + 136) / 272)
exe '2resize ' . ((&lines * 24 + 31) / 62)
exe 'vert 2resize ' . ((&columns * 90 + 136) / 272)
exe '3resize ' . ((&lines * 15 + 31) / 62)
exe 'vert 3resize ' . ((&columns * 90 + 136) / 272)
exe '4resize ' . ((&lines * 15 + 31) / 62)
exe 'vert 4resize ' . ((&columns * 90 + 136) / 272)
exe '5resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 5resize ' . ((&columns * 90 + 136) / 272)
exe '6resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 6resize ' . ((&columns * 90 + 136) / 272)
exe '7resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 7resize ' . ((&columns * 90 + 136) / 272)
exe '8resize ' . ((&lines * 20 + 31) / 62)
exe 'vert 8resize ' . ((&columns * 90 + 136) / 272)
exe '9resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 9resize ' . ((&columns * 90 + 136) / 272)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 199 - ((22 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
199
normal! 061|
wincmd w
argglobal
edit app/views/layouts/application.html.haml
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 18 - ((16 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
18
normal! 0
wincmd w
argglobal
edit app/controllers/admin/survey_iterations_controller.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 12 - ((8 * winheight(0) + 7) / 15)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 024|
wincmd w
argglobal
edit app/jobs/publish_to_sg_job.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 13 - ((12 * winheight(0) + 7) / 15)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
13
normal! 023|
wincmd w
argglobal
edit app/models/survey_question.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 23 - ((10 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
23
normal! 0
wincmd w
argglobal
edit app/models/survey_page.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 73 - ((9 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
73
normal! 024|
wincmd w
argglobal
edit app/helpers/admin/survey_iterations_helper.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 19 - ((18 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 010|
wincmd w
argglobal
edit app/views/admin/survey_iterations/_details_cell.html.haml
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 35 - ((16 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
35
normal! 030|
wincmd w
argglobal
edit app/jobs/delete_from_sg_job.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 2 - ((1 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 020|
wincmd w
exe '1resize ' . ((&lines * 24 + 31) / 62)
exe 'vert 1resize ' . ((&columns * 90 + 136) / 272)
exe '2resize ' . ((&lines * 24 + 31) / 62)
exe 'vert 2resize ' . ((&columns * 90 + 136) / 272)
exe '3resize ' . ((&lines * 15 + 31) / 62)
exe 'vert 3resize ' . ((&columns * 90 + 136) / 272)
exe '4resize ' . ((&lines * 15 + 31) / 62)
exe 'vert 4resize ' . ((&columns * 90 + 136) / 272)
exe '5resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 5resize ' . ((&columns * 90 + 136) / 272)
exe '6resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 6resize ' . ((&columns * 90 + 136) / 272)
exe '7resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 7resize ' . ((&columns * 90 + 136) / 272)
exe '8resize ' . ((&lines * 20 + 31) / 62)
exe 'vert 8resize ' . ((&columns * 90 + 136) / 272)
exe '9resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 9resize ' . ((&columns * 90 + 136) / 272)
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
let g:this_obsession = v:this_session
unlet SessionLoad
" vim: set ft=vim :
