--
Dss={}
local dssflag = false
--rewrite
-- function Auxiliary.Stringid(code,id)
-- 	if dssflag==true then
-- 		dssflag = false
-- 		Dss.setting()
-- 	end
-- 	return code*16+id
-- end
function Dss.setting()
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCondition(Dss.drawcon)
	e2:SetTarget(Dss.drawtg)
	e2:SetOperation(Dss.drawop)
	Duel.RegisterEffect(e2, 0)
end
function Dss.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1 
end
function Dss.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dt=Duel.GetDrawCount(Duel.GetTurnPlayer())
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
		
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetCondition(Dss.drawcon2)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetOperation(Dss.drawop2)
		Duel.RegisterEffect(e0, Duel.GetTurnPlayer())
	end
end
function Dss.drawop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max then return end
end
function Dss.drawcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END 
end
function Dss.drawop2(e,tp,eg,ep,ev,re,r,rp)
--	if Duel.SelectYesNo(Duel.GetTurnPlayer(), 25096*16+0) then 
	Duel.Draw(Duel.GetTurnPlayer(),1,REASON_RULE)
--	end
	e:Reset()
end