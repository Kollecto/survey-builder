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
badd +95 app/models/user.rb
badd +27 config/secrets.yml
badd +122 ~/dotfiles/vim/.vimrc.ruby
badd +5 config/database.yml
badd +19 app/controllers/application_controller.rb
badd +4 db/migrate/20150721215149_add_stuff_to_users.rb
badd +54 config/routes.rb
badd +18 app/controllers/survey_submissions_controller.rb
badd +3 app/views/survey_submissions/start.html.haml
badd +26 app/models/ability.rb
badd +31 app/views/survey_submissions/take_survey.html.haml
badd +1 app/views/devise/registrations/new.html.haml
badd +4 db/migrate/20150721222217_create_join_table_user_taste_category.rb
badd +5 app/models/taste_category.rb
badd +2 app/controllers/registrations_controller.rb
badd +35 app/views/shared/_main_nav.html.haml
badd +45 app/assets/stylesheets/bootstrap-overrides.scss
badd +18 app/views/layouts/application.html.haml
badd +7 app/views/home/home.html.haml
badd +24 app/models/survey_submission.rb
badd +12 app/views/devise/sessions/new.html.haml
badd +19 db/schema.rb
badd +16 app/models/survey_iteration.rb
badd +2 app/controllers/survey_questions_controller.rb
badd +1 spec/models/survey_page_spec.rb
badd +16 app/models/survey_page.rb
badd +78 app/models/survey_question.rb
badd +27 app/models/concerns/survey_page_navigation.rb
badd +26 app/controllers/home_controller.rb
badd +81 config/environments/production.rb
badd +37 Gemfile
badd +22 Capfile
badd +34 config/deploy/staging.rb
badd +12 config/deploy.rb
badd +30 config/application.rb
badd +87 config/environments/staging.rb
badd +5 app/controllers/admin/base_controller.rb
badd +3 app/views/admin/base/dashboard.html.haml
badd +13 app/views/admin/base/_admin_frame.html.haml
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
badd +10 app/controllers/admin/survey_iterations_controller.rb
badd +7 app/views/admin/survey_iterations/index.html.haml
badd +1 app/views/admin/survey_iterations/_table.html.haml
badd +2 app/views/admin/survey_iterations/_table_row.html.haml
badd +2 app/views/admin/survey_iterations/_details_cell.html.haml
badd +35 app/helpers/admin/survey_iterations_helper.rb
badd +35 app/models/survey_option.rb
badd +13 app/jobs/publish_to_sg_job.rb
badd +1 config/initializers/active_job.rb
badd +2 app/views/admin/survey_iterations/new.html.haml
badd +9 app/views/admin/survey_iterations/_form.html.haml
badd +4 app/views/admin/survey_iterations/edit.html.haml
badd +3 app/assets/javascripts/shared.coffee
badd +1 app/controllers/survey_iterations_controller.rb
badd +29 app/views/admin/survey_iterations/show.html.haml
badd +5 db/migrate/20150724232443_add_sg_publishing_jid_to_survey_iterations.rb
badd +1 app/helpers/survey_iterations_helper.rb
badd +2 app/jobs/delete_from_sg_job.rb
badd +6 db/migrate/20150725002217_add_deletion_datetimes_to_survey_iterations.rb
badd +11 app/jobs/import_from_google_drive_job.rb
badd +1 app/controllers/survey_pages_controller.rb
badd +12 app/controllers/admin/survey_pages_controller.rb
badd +15 app/views/admin/survey_pages/index.html.haml
badd +10 app/views/admin/survey_pages/_table.html.haml
badd +4 app/views/admin/survey_pages/_table_row.html.haml
badd +3 app/views/admin/survey_pages/_details_cell.html.haml
badd +7 app/controllers/admin/survey_questions_controller.rb
badd +11 app/views/admin/survey_questions/index.html.haml
badd +11 app/views/admin/survey_questions/_table.html.haml
badd +1 app/views/admin/survey_questions/_table_row.html.haml
badd +7 app/views/admin/survey_questions/_details_cell.html.haml
badd +9 app/controllers/admin/survey_options_controller.rb
badd +11 app/views/admin/survey_options/index.html.haml
badd +12 app/views/admin/survey_options/_table.html.haml
badd +2 app/views/admin/survey_options/_table_row.html.haml
badd +2 app/views/admin/survey_options/_details_cell.html.haml
badd +10 db/migrate/20150725221113_change_google_auth_token_to_google_access_token_for_users.rb
argglobal
silent! argdel *
edit app/views/admin/survey_iterations/_details_cell.html.haml
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
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
exe '1resize ' . ((&lines * 29 + 31) / 62)
exe 'vert 1resize ' . ((&columns * 90 + 136) / 272)
exe '2resize ' . ((&lines * 29 + 31) / 62)
exe 'vert 2resize ' . ((&columns * 90 + 136) / 272)
exe '3resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 3resize ' . ((&columns * 90 + 136) / 272)
exe '4resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 4resize ' . ((&columns * 90 + 136) / 272)
exe '5resize ' . ((&lines * 20 + 31) / 62)
exe 'vert 5resize ' . ((&columns * 90 + 136) / 272)
exe '6resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 6resize ' . ((&columns * 90 + 136) / 272)
exe '7resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 7resize ' . ((&columns * 90 + 136) / 272)
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
let s:l = 25 - ((23 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
25
normal! 057|
wincmd w
argglobal
edit app/models/user.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 59 - ((18 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
59
normal! 05|
wincmd w
argglobal
edit app/models/survey_iteration.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 157 - ((14 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
157
normal! 021|
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
let s:l = 14 - ((7 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
14
normal! 0
wincmd w
argglobal
edit app/views/shared/_main_nav.html.haml
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 31 - ((15 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
31
normal! 015|
wincmd w
argglobal
edit app/views/admin/survey_iterations/_form.html.haml
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 9 - ((5 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 033|
wincmd w
argglobal
edit app/controllers/application_controller.rb
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 19 - ((15 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 017|
wincmd w
6wincmd w
exe '1resize ' . ((&lines * 29 + 31) / 62)
exe 'vert 1resize ' . ((&columns * 90 + 136) / 272)
exe '2resize ' . ((&lines * 29 + 31) / 62)
exe 'vert 2resize ' . ((&columns * 90 + 136) / 272)
exe '3resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 3resize ' . ((&columns * 90 + 136) / 272)
exe '4resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 4resize ' . ((&columns * 90 + 136) / 272)
exe '5resize ' . ((&lines * 20 + 31) / 62)
exe 'vert 5resize ' . ((&columns * 90 + 136) / 272)
exe '6resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 6resize ' . ((&columns * 90 + 136) / 272)
exe '7resize ' . ((&lines * 19 + 31) / 62)
exe 'vert 7resize ' . ((&columns * 90 + 136) / 272)
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
