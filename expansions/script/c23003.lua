 
--秘神流雏 健山雏
function c23003.initial_effect(c)
    --draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23003,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(c23003.con)
	e1:SetTarget(c23003.tg)
	e1:SetOperation(c23003.op)
	c:RegisterEffect(e1)
    --disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23003,0))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c23003.descon)
	e3:SetTarget(c23003.destg)
	e3:SetOperation(c23003.desop)
	c:RegisterEffect(e3)
end
function c23003.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c23003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23003.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c23003.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c23003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c23003.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
