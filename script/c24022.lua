 
---废狱-紧闭的恋之瞳·古明地恋
function c24022.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x625),1)
	c:EnableReviveLimit()
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24022,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetLabel(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCondition(c24022.condition)
	e1:SetOperation(c24022.activate)
	c:RegisterEffect(e1)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c24022.efilter)
	c:RegisterEffect(e3)
	--direct atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
end
function c24022.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c24022.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=1 or Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 then return end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,70,71,72)
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (op~=0 and tc:IsType(TYPE_MONSTER)) or (op~=1 and tc:IsType(TYPE_SPELL)) or (op~=2 and tc:IsType(TYPE_TRAP)) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function c24022.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
