 
--幽冥楼阁的亡灵✿西行寺幽幽子
function c20080.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20080.spcon)
	e1:SetOperation(c20080.spop)
	c:RegisterEffect(e1)
	--summon,flip,special
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c20080.retreg)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetDescription(aux.Stringid(20080,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCondition(c20080.retcon)
	e3:SetTarget(c20080.rettg)
	e3:SetOperation(c20080.retop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e4)
	--adc
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20080,1))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c20080.addcost)
	e5:SetTarget(c20080.addct)
	e5:SetOperation(c20080.addc)
	c:RegisterEffect(e5)
	--cannot be xyzmat
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
	--synchro summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(c20080.synlimit)
	c:RegisterEffect(e5)
end
function c20080.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c20080.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetDecktopGroup(tp,3)
	local remv=g:FilterCount(Card.IsAbleToRemoveAsCost,nil)>2
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and remv
end
function c20080.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:IsType(TYPE_SPIRIT)
end
function c20080.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local rg=Duel.GetOperatedGroup()
	local ct=rg:FilterCount(c20080.filter,nil,nil)
	if ct==0 then
		e:GetHandler():RegisterFlagEffect(20080,RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c20080.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(20080)>0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
	if Duel.GetCurrentPhase()==PHASE_END then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(200800,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,3)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(200800,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
	end
end
function c20080.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(200800)>0 and Duel.GetTurnPlayer()~=tp
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(200800)>0 and Duel.GetTurnPlayer()~=tp end
end
function c20080.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c20080.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c20080.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	local remv=g:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0
	if chk==0 then return remv end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c20080.xfilter(c)
	return c:IsFaceup() and c:IsCode(20086)
end
function c20080.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c20080.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20080.xfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c20080.xfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
end
function c20080.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28b,2)
	end
end
