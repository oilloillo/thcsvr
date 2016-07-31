 
--绯想✿洩矢诹访子
function c200020.initial_effect(c)
	--c:EnableReviveLimit()
	--[[cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)]]
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c200020.spcon)
	e1:SetOperation(c200020.spop)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c200020.lvcon)
	e2:SetOperation(c200020.lvop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--atk def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c200020.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENCE)
	c:RegisterEffect(e3)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c200020.efcon)
	e2:SetOperation(c200020.efop)
	c:RegisterEffect(e2)
end
function c200020.spfilter(c)
	local x=c:GetOriginalCode()
	return c:IsSetCard(0x208) and c:IsReleasable() and c:GetLevel()<=7
end
function c200020.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c200020.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c200020.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c200020.spfilter,tp,LOCATION_HAND,0,1,1,c)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function c200020.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==re:GetHandler()
end
function c200020.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local lv=e:GetLabelObject():GetLabel()
		local clv=c:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		if Duel.SelectYesNo(tp,aux.Stringid(200020,0)) then
			local token=Duel.CreateToken(tp,200120)
			Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--			Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c200020.value(e,c)
	return c:GetLevel()*300
end
function c200020.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ or r==REASON_SYNCHRO
end
function c200020.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c200020.drcon)
	e1:SetTarget(c200020.drtg)
	e1:SetOperation(c200020.drop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		if rc:IsType(TYPE_XYZ) then	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		else if rc:IsType(TYPE_TUNER) then e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO+TYPE_TUNER)
			else e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO) end
		end
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c200020.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ or e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c200020.filter2(c)
	return c:IsCode(200220) and c:IsAbleToHand()
end
function c200020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200020.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200020.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200020.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200020.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end